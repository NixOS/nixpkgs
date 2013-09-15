{ stdenv, fetchurl, pkgconfig, libxml2, gnutls, devicemapper, perl, python
, iproute, iptables, readline, lvm2, utillinux, udev, libpciaccess, gettext
, libtasn1, ebtables, libgcrypt, yajl, makeWrapper, pmutils, libcap_ng
}:

let version = "1.1.2"; in

stdenv.mkDerivation {
  name = "libvirt-${version}";

  src = fetchurl {
    url = "http://libvirt.org/sources/libvirt-${version}.tar.gz";
    md5 = "1835bbfa492099bce12e2934870e5611";
  };

  buildInputs =
    [ pkgconfig libxml2 gnutls devicemapper perl python readline lvm2
      utillinux udev libpciaccess gettext libtasn1 libgcrypt yajl makeWrapper
      libcap_ng
    ];

  # see http://www.mail-archive.com/libvir-list@redhat.com/msg83693.html
  patches = [ ./securtyfs_userns.patch ];

  preConfigure =
    ''
      PATH=${iproute}/sbin:${iptables}/sbin:${ebtables}/sbin:${lvm2}/sbin:${udev}/sbin:$PATH
      patchShebangs . # fixes /usr/bin/python references
    '';

  configureFlags = "--localstatedir=/var --sysconfdir=/etc --with-init-script=redhat --without-macvtap";

  installFlags = "localstatedir=$(TMPDIR)/var sysconfdir=$(out)/etc";

  postInstall =
    ''
      substituteInPlace $out/libexec/libvirt-guests.sh \
        --replace "$out/bin" "${gettext}/bin"
      wrapProgram $out/sbin/libvirtd \
        --prefix PATH : ${iptables}/sbin:${iproute}/sbin:${pmutils}/bin
    '';

  enableParallelBuilding = true;
  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  meta = {
    homepage = http://libvirt.org/;
    description = "A toolkit to interact with the virtualization capabilities of recent versions of Linux (and other OSes)";
    license = "LGPLv2+";
    platforms = stdenv.lib.platforms.linux;
  };
}
