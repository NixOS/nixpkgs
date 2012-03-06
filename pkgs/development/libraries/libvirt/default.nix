{ stdenv, fetchurl, pkgconfig, libxml2, gnutls, devicemapper, perl, python
, iproute, iptables, readline, lvm2, utillinux, udev, libpciaccess, gettext 
, libtasn1, ebtables, libgcrypt
}:

let version = "0.9.7"; in

stdenv.mkDerivation {
  name = "libvirt-${version}";

  src = fetchurl {
    url = "http://libvirt.org/sources/libvirt-${version}.tar.gz";
    sha256 = "08xg0pfjqfia37xby9187ycsxkrxaz99w9rcq206cz8pwnzhbzr9";
  };

  buildInputs =
    [ pkgconfig libxml2 gnutls devicemapper perl python readline lvm2
      utillinux udev libpciaccess gettext libtasn1 libgcrypt
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
      substituteInPlace $out/etc/rc.d/init.d/libvirt-guests \
        --replace "$out/bin" "${gettext}/bin"
    '';

  meta = {
    homepage = http://libvirt.org/;
    description = "A toolkit to interact with the virtualization capabilities of recent versions of Linux (and other OSes)";
    license = "LGPLv2+";
    platforms = stdenv.lib.platforms.linux;
  };
}
