{ stdenv, fetchurl, pkgconfig, libxml2, gnutls, devicemapper, perl, python
, iproute, iptables, readline, lvm2, utillinux, udev, libpciaccess, gettext 
, libtasn1, ebtables
}:

let version = "0.9.0-rc2"; in

stdenv.mkDerivation {
  name = "libvirt-${version}";

  src = fetchurl {
    url = "http://libvirt.org/sources/libvirt-${version}.tar.gz";
    sha256 = "1blfx5rh8in5qn91944fz1mxv8jyigac4br8qmh7hvrw3wj2wrl9";
  };

  buildInputs =
    [ pkgconfig libxml2 gnutls devicemapper perl python readline lvm2
      utillinux udev libpciaccess gettext libtasn1
    ];

  preConfigure =
    ''
      PATH=${iproute}/sbin:${iptables}/sbin:${ebtables}/sbin:${lvm2}/sbin:${udev}/sbin:$PATH
    '';

  configureFlags = "--localstatedir=/var --with-init-script=redhat";

  installFlags = "localstatedir=$(TMPDIR)/var";

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
