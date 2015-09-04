{ stdenv, fetchurl, pkgconfig, libxml2, gnutls, devicemapper, perl, python
, iproute, iptables, readline, lvm2, utillinux, udev, libpciaccess, gettext
, libtasn1, ebtables, libgcrypt, yajl, makeWrapper, pmutils, libcap_ng
, dnsmasq, libnl, libpcap, libxslt, xhtml1
, pythonPackages, perlPackages
}:

let version = "1.2.18"; in

assert version == pythonPackages.libvirt.version;

stdenv.mkDerivation rec {
  name = "libvirt-${version}";

  src = fetchurl {
    url = "http://libvirt.org/sources/${name}.tar.gz";
    sha256 = "1pkaxcg77izi1yzjc0wjav985dr11bx2hvcqxlgx5kjcmwcgz9fm";
  };

  buildInputs = [
    pkgconfig libxml2 gnutls devicemapper perl python readline lvm2
    utillinux udev libpciaccess gettext libtasn1 libgcrypt yajl makeWrapper
    libcap_ng libnl libxslt xhtml1 perlPackages.XMLXPath
  ];

  preConfigure = ''
    PATH=${iproute}/sbin:${iptables}/sbin:${ebtables}/sbin:${lvm2}/sbin:${udev}/sbin:${dnsmasq}/bin:$PATH
    patchShebangs . # fixes /usr/bin/python references
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--with-init-script=redhat"
    "--with-macvtap"
    "--with-virtualport"
    "--with-libpcap"
  ];

  installFlags = [
    "localstatedir=$(TMPDIR)/var"
    "sysconfdir=$(out)/etc"
  ];

  postInstall = ''
    sed -i 's/ON_SHUTDOWN=suspend/ON_SHUTDOWN=''${ON_SHUTDOWN:-suspend}/' $out/libexec/libvirt-guests.sh
    substituteInPlace $out/libexec/libvirt-guests.sh \
      --replace "$out/bin" "${gettext}/bin"
    wrapProgram $out/sbin/libvirtd \
      --prefix PATH : ${iptables}/sbin:${iproute}/sbin:${pmutils}/bin
  '';

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  meta = with stdenv.lib; {
    homepage = http://libvirt.org/;
    repositories.git = git://libvirt.org/libvirt.git;
    description = ''
      A toolkit to interact with the virtualization capabilities of recent
      versions of Linux (and other OSes)
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
