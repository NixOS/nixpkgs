{ stdenv, fetchurl, fetchgit
, pkgconfig, makeWrapper, libtool, autoconf, automake
, coreutils, libxml2, gnutls, perl, python2, attr
, iproute, iptables, readline, lvm2, utillinux, systemd, libpciaccess, gettext
, libtasn1, ebtables, libgcrypt, yajl, pmutils, libcap_ng, libapparmor
, dnsmasq, libnl, libpcap, libxslt, xhtml1, numad, numactl, perlPackages
, curl, libiconv, gmp, zfs, parted, bridge-utils, dmidecode
, enableXen ? false, xen ? null
, enableIscsi ? false, openiscsi
}:

with stdenv.lib;

# if you update, also bump <nixpkgs/pkgs/development/python-modules/libvirt/default.nix> and SysVirt in <nixpkgs/pkgs/top-level/perl-packages.nix>
let
  buildFromTarball = stdenv.isDarwin;
in stdenv.mkDerivation rec {
  name = "libvirt-${version}";
  version = "4.7.0";

  src =
    if buildFromTarball then
      fetchurl {
        url = "http://libvirt.org/sources/${name}.tar.xz";
        sha256 = "1r37aw1xxlwjkk4n6k503mw1caldijz8n7x86xdaq90n6bvpkhlj";
      }
    else
      fetchgit {
        url = git://libvirt.org/libvirt.git;
        rev = "v${version}";
        sha256 = "17byylhx0bny4b771hqv92d87a5dg21a5qjv861y50sckgwwi6f1";
        fetchSubmodules = true;
      };

  nativeBuildInputs = [ makeWrapper pkgconfig ];
  buildInputs = [
    libxml2 gnutls perl python2 readline gettext libtasn1 libgcrypt yajl
    libxslt xhtml1 perlPackages.XMLXPath curl libpcap
  ] ++ optionals (!buildFromTarball) [
    libtool autoconf automake
  ] ++ optionals stdenv.isLinux [
    libpciaccess lvm2 utillinux systemd libnl numad zfs
    libapparmor libcap_ng numactl attr parted
  ] ++ optionals (enableXen && stdenv.isLinux && stdenv.isx86_64) [
    xen
  ] ++ optionals enableIscsi [
    openiscsi
  ] ++ optionals stdenv.isDarwin [
    libiconv gmp
  ];

  preConfigure = ''
    ${ optionalString (!buildFromTarball) "./bootstrap --no-git --gnulib-srcdir=$(pwd)/.gnulib" }

    PATH=${stdenv.lib.makeBinPath ([ dnsmasq ] ++ optionals stdenv.isLinux [ iproute iptables ebtables lvm2 systemd numad ] ++ optionals enableIscsi [ openiscsi ])}:$PATH

    # the path to qemu-kvm will be stored in VM's .xml and .save files
    # do not use "''${qemu_kvm}/bin/qemu-kvm" to avoid bound VMs to particular qemu derivations
    substituteInPlace src/lxc/lxc_conf.c \
      --replace 'lxc_path,' '"/run/libvirt/nix-emulators/libvirt_lxc",'

    patchShebangs . # fixes /usr/bin/python references
  '';

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/var/lib"
    "--with-libpcap"
    "--with-qemu"
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
  ] ++ optionals (stdenv.isLinux && zfs != null) [
    "--with-storage-zfs"
  ] ++ optionals enableIscsi [
    "--with-storage-iscsi"
  ] ++ optionals stdenv.isDarwin [
    "--with-init-script=none"
  ];

  installFlags = [
    "localstatedir=$(TMPDIR)/var"
    "sysconfdir=$(out)/var/lib"
  ];


  postInstall = let
    binPath = [ iptables iproute pmutils numad numactl bridge-utils dmidecode dnsmasq ebtables ] ++ optionals enableIscsi [ openiscsi ];
  in ''
    substituteInPlace $out/libexec/libvirt-guests.sh \
      --replace 'ON_SHUTDOWN=suspend' 'ON_SHUTDOWN=''${ON_SHUTDOWN:-suspend}' \
      --replace "$out/bin"            '${gettext}/bin' \
      --replace 'lock/subsys'         'lock' \
      --replace 'gettext.sh'          'gettext.sh
  # Added in nixpkgs:
  gettext() { "${gettext}/bin/gettext" "$@"; }
  '
  '' + optionalString stdenv.isLinux ''
    substituteInPlace $out/lib/systemd/system/libvirtd.service --replace /bin/kill ${coreutils}/bin/kill
    rm $out/lib/systemd/system/{virtlockd,virtlogd}.*
    wrapProgram $out/sbin/libvirtd \
      --prefix PATH : /run/libvirt/nix-emulators:${makeBinPath binPath}
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
