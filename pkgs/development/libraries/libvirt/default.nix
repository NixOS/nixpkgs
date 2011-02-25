{ stdenv, fetchurl, pkgconfig, libxml2, gnutls, devicemapper, perl, python
, iproute, iptables, readline, lvm2, utillinux, udev, libpciaccess }:

let version = "0.8.8"; in

stdenv.mkDerivation {
  name = "libvirt-${version}";

  src = fetchurl {
    url = "http://libvirt.org/sources/libvirt-${version}.tar.gz";
    sha256 = "04z1757qpi3ssnjv5h2qnw1sds2m50yxk67cbdam6w4i50vyl2h3";
  };

  buildInputs =
    [ pkgconfig libxml2 gnutls devicemapper perl python readline lvm2
      utillinux udev libpciaccess
    ];

  preConfigure =
    ''
      PATH=${iproute}/sbin:${iptables}/sbin:${lvm2}/sbin:${udev}/sbin:$PATH
    '';

  configureFlags = "--localstatedir=/var";

  installFlags = "localstatedir=$(TMPDIR)/var";

  meta = {
    homepage = http://libvirt.org/;
    description = "A toolkit to interact with the virtualization capabilities of recent versions of Linux (and other OSes).";
    license = "LGPLv2+";
    platforms = stdenv.lib.platforms.linux;
  };
}
