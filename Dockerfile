FROM alpine
RUN apk update
RUN apk add tftp-hpa dnsmasq
ADD defaults/tftpd-hpa /etc/default/tftpd-hpa
ADD defaults/pxelinux.cfg/default /var/lib/tftpboot/pxelinux.cfg/default
RUN mkdir -p /var/lib/tftpboot
WORKDIR /var/lib/tftpboot
RUN apk add gpgme
ADD defaults/coreos.pub /root/.coreos.pub
RUN gpg --import /root/.coreos.pub
RUN wget http://beta.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz \
  && wget http://beta.release.core-os.net/amd64-usr/current/coreos_production_pxe.vmlinuz.sig \
  && gpg --verify coreos_production_pxe.vmlinuz.sig \
  && wget http://beta.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz \
  && wget http://beta.release.core-os.net/amd64-usr/current/coreos_production_pxe_image.cpio.gz.sig \
  && gpg --verify coreos_production_pxe_image.cpio.gz.sig
ADD defaults/dnsmasq.conf /etc/dnsmasq.conf
WORKDIR /root/
ADD run.sh run
RUN chmod +x run
CMD ./run
EXPOSE 69/udp 69/tcp 8099/udp 8099/tcp
