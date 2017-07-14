{ stdenv, fetchurl, fetchpatch
, pkgconfig, makeWrapper
, libxml2, gnutls, devicemapper, perl, python2, attr
, iproute, iptables, readline, lvm2, utillinux, systemd, libpciaccess, gettext
, libtasn1, ebtables, libgcrypt, yajl, pmutils, libcap_ng, libapparmor
, dnsmasq, libnl, libpcap, libxslt, xhtml1, numad, numactl, perlPackages
, curl, libiconv, gmp, xen, zfs, parted
}:

with stdenv.lib;

# if you update, also bump pythonPackages.libvirt or it will break
stdenv.mkDerivation rec {
  name = "libvirt-${version}";
  version = "3.1.0";

  src = fetchurl {
    url = "http://libvirt.org/sources/${name}.tar.xz";
    sha256 = "1a9j6yqfy7i5yv414wk6nv26a5bpfyyg0rpcps6ybi6a1yd04ybq";
  };

  patches = [ ./build-on-bsd.patch ];

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [
    libxml2 gnutls perl python2 readline gettext libtasn1 libgcrypt yajl
    libxslt xhtml1 perlPackages.XMLXPath curl libpcap
  ] ++ optionals stdenv.isLinux [
    libpciaccess devicemapper lvm2 utillinux systemd libnl numad zfs
    libapparmor libcap_ng numactl xen attr parted
  ] ++ optionals stdenv.isDarwin [
     libiconv gmp
  ];

  preConfigure = optionalString stdenv.isLinux ''
    PATH=${stdenv.lib.makeBinPath [ iproute iptables ebtables lvm2 systemd ]}:$PATH
    substituteInPlace configure \
      --replace 'as_dummy="/bin:/usr/bin:/usr/sbin"' 'as_dummy="${numad}/bin"'
  '' + ''
    PATH=${dnsmasq}/bin:$PATH
    patchShebangs . # fixes /usr/bin/python references
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/var/lib"
    "--with-libpcap"
    "--with-vmware"
    "--with-vbox"
    "--with-test"
    "--with-esx"
    "--with-remote"
  ] ++ optionals stdenv.isLinux [
    "--with-attr"
    "--with-apparmor"
    "--with-secdriver-apparmor"
    "--with-numad"
    "--with-macvtap"
    "--with-virtualport"
    "--with-init-script=systemd+redhat"
    "--with-storage-disk"
    "--with-storage-zfs"
  ] ++ optionals stdenv.isDarwin [
    "--with-init-script=none"
  ];

  installFlags = [
    "localstatedir=$(TMPDIR)/var"
    "sysconfdir=$(out)/var/lib"
  ];

  postInstall = ''
    sed -i 's/ON_SHUTDOWN=suspend/ON_SHUTDOWN=''${ON_SHUTDOWN:-suspend}/' $out/libexec/libvirt-guests.sh
    substituteInPlace $out/libexec/libvirt-guests.sh \
      --replace "$out/bin" "${gettext}/bin" \
      --replace "lock/subsys" "lock"
    sed -e "/gettext\.sh/a \\\n# Added in nixpkgs:\ngettext() { \"${gettext}/bin/gettext\" \"\$@\"; }" \
        -i "$out/libexec/libvirt-guests.sh"
  '' + optionalString stdenv.isLinux ''
    rm $out/lib/systemd/system/{virtlockd,virtlogd}.*
    wrapProgram $out/sbin/libvirtd \
      --prefix PATH : ${makeBinPath [ iptables iproute pmutils numad numactl ]}
  '';

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  meta = {
    homepage = http://libvirt.org/;
    repositories.git = git://libvirt.org/libvirt.git;
    description = ''
      A toolkit to interact with the virtualization capabilities of recent
      versions of Linux (and other OSes)
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
