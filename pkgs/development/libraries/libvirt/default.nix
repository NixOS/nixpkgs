{ stdenv, fetchurl, pkgconfig, libxml2, gnutls, devicemapper, perl, python
, iproute, iptables, readline, lvm2, utillinux, udev, libpciaccess, gettext
, libtasn1, ebtables, libgcrypt, yajl, makeWrapper, pmutils, libcap_ng
, dnsmasq
}:

let version = "1.2.2"; in

stdenv.mkDerivation rec {
  name = "libvirt-${version}";

  src = fetchurl {
    url = "http://libvirt.org/sources/${name}.tar.gz";
    sha256 = "1hxvgh2fp2fk3wva7fnbz2pk6g5217wrmf9xwikiphn50zipg0x4";
  };

  buildInputs = [
    pkgconfig libxml2 gnutls devicemapper perl python readline lvm2
    utillinux udev libpciaccess gettext libtasn1 libgcrypt yajl makeWrapper
    libcap_ng
  ];

  preConfigure = ''
    PATH=${iproute}/sbin:${iptables}/sbin:${ebtables}/sbin:${lvm2}/sbin:${udev}/sbin:${dnsmasq}/bin:$PATH
    patchShebangs . # fixes /usr/bin/python references
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-init-script=redhat"
    "--without-macvtap"
  ];

  installFlags = [
    "localstatedir=$(TMPDIR)/var"
    "sysconfdir=$(out)/etc"
  ];

  postInstall = ''
    substituteInPlace $out/libexec/libvirt-guests.sh \
      --replace "$out/bin" "${gettext}/bin"
    wrapProgram $out/sbin/libvirtd \
      --prefix PATH : ${iptables}/sbin:${iproute}/sbin:${pmutils}/bin
  '';

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  meta = with stdenv.lib; {
    homepage = http://libvirt.org/;
    description = ''
      A toolkit to interact with the virtualization capabilities of recent
      versions of Linux (and other OSes)
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
