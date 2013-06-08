{ stdenv, fetchurl, pkgconfig, libxml2, gnutls, devicemapper, perl, python
, iproute, iptables, readline, lvm2, utillinux, udev, libpciaccess, gettext 
, libtasn1, ebtables, libgcrypt, yajl
}:

let version = "1.0.3"; in

stdenv.mkDerivation {
  name = "libvirt-${version}";

  src = fetchurl {
    url = "http://libvirt.org/sources/libvirt-${version}.tar.gz";
    sha256 = "0mr727n0ygxk6y69srg3ahmjd7wligamw683x2snmz6wgk6llkzn";
  };

  buildInputs =
    [ pkgconfig libxml2 gnutls devicemapper perl python readline lvm2
      utillinux udev libpciaccess gettext libtasn1 libgcrypt yajl
    ];

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
