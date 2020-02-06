{ stdenv, fetchurl, fetchgit
, pkgconfig, makeWrapper, libtool, autoconf, automake, fetchpatch
, coreutils, libxml2, gnutls, perl, python2, attr
, iproute, iptables, readline, lvm2, utillinux, systemd, libpciaccess, gettext
, libtasn1, ebtables, libgcrypt, yajl, pmutils, libcap_ng, libapparmor
, dnsmasq, libnl, libpcap, libxslt, xhtml1, numad, numactl, perlPackages
, curl, libiconv, gmp, zfs, parted, bridge-utils, dmidecode
, enableXen ? false, xen ? null
, enableIscsi ? false, openiscsi
, enableCeph ? false, ceph
}:

with stdenv.lib;

# if you update, also bump <nixpkgs/pkgs/development/python-modules/libvirt/default.nix> and SysVirt in <nixpkgs/pkgs/top-level/perl-packages.nix>
let
  buildFromTarball = stdenv.isDarwin;
in stdenv.mkDerivation rec {
  pname = "libvirt";
  version = "5.4.0";

  src =
    if buildFromTarball then
      fetchurl {
        url = "http://libvirt.org/sources/${pname}-${version}.tar.xz";
        sha256 = "0ywf8m9yz2hxnic7fylzlmgy4m353r4vv5zsvp89zq5yh4h81yhw";
      }
    else
      fetchgit {
        url = git://libvirt.org/libvirt.git;
        rev = "v${version}";
        sha256 = "1dja1mf295w0sl83zag62c4j55cfbzzfbhdxpkyv2zm3zv0mwdyc";
        fetchSubmodules = true;
      };

  patches = optionals (!stdenv.isDarwin) [
    (fetchpatch {
      name = "5.4.0-CVE-2019-10161.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=aed6a032cead4386472afb24b16196579e239580";
      sha256 = "19k9z9xx68nf03igbgy1imxnlp5ppj7cgdbq9kri3s834hkjcygs";
    })
  ] ++ [
    (fetchpatch {
      name = "5.4.0-CVE-2019-10166.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=db0b78457f183e4c7ac45bc94de86044a1e2056a";
      sha256 = "17pd1rab2mxj4q0vg30vi2gh78mf52ik1p5l12wrghb0wjf7swml";
    })
    (fetchpatch {
      name = "5.4.0-CVE-2019-10167.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=8afa68bac0cf99d1f8aaa6566685c43c22622f26";
      sha256 = "0hgbwk0y2n6ihzjk8vqabhw914axjqgzcb7c5xx893r86c54c0ml";
    })
    (fetchpatch {
      name = "5.4.0-CVE-2019-10168.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=bf6c2830b6c338b1f5699b095df36f374777b291";
      sha256 = "0s4hc3hsjncx1852ndjas1nng9v23pxf4mi1jxcajsqvhw89la0g";
    })
  ];

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
  ] ++ optionals enableCeph [
    ceph
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
    "QEMU_BRIDGE_HELPER=/run/wrappers/bin/qemu-bridge-helper"
    "QEMU_PR_HELPER=/run/libvirt/nix-helpers/qemu-pr-helper"
    "EBTABLES_PATH=${ebtables}/bin/ebtables-legacy"
    "--with-attr"
    "--with-apparmor"
    "--with-secdriver-apparmor"
    "--with-numad"
    "--with-macvtap"
    "--with-virtualport"
    "--with-storage-disk"
  ] ++ optionals (stdenv.isLinux && zfs != null) [
    "--with-storage-zfs"
  ] ++ optionals enableIscsi [
    "--with-storage-iscsi"
  ] ++ optionals enableCeph [
    "--with-storage-rbd"
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
      --replace 'ON_BOOT=start'       'ON_BOOT=''${ON_BOOT:-start}' \
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
    maintainers = with maintainers; [ fpletz globin ];
  };
}
