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
  name = "libvirt-${version}";
  version = "4.10.0";

  src =
    if buildFromTarball then
      fetchurl {
        url = "http://libvirt.org/sources/${name}.tar.xz";
        sha256 = "0v17zzyyb25nn9l18v5244myg7590dp6ppwgi8xysipifc0q77bz";
      }
    else
      fetchgit {
        url = git://libvirt.org/libvirt.git;
        rev = "v${version}";
        sha256 = "0dlpv3v6jpbmgvhpn29ryp0w2a1xny8ciqid8hnlf3klahz9kwz9";
        fetchSubmodules = true;
      };

  patches = [
    (fetchpatch {
      name = "4.10.0-CVE-2019-10132-1.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=8d12118171a250150f2cb16448c49271a1dcb077";
      sha256 = "1s8xm0zn63wciaxzrcf5ld9d3r2hn9k31p41addhyrxivgvkvk4d";
    })
    (fetchpatch {
      name = "4.10.0-CVE-2019-10132-2.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=a712f01682078f48d3c258bff8cd523ab9100b0d";
      sha256 = "12wzv190l7gp3fpa1qirgy5l6w674pfpw06jb15gifrwhy7x9j06";
    })
    (fetchpatch {
      name = "4.10.0-CVE-2019-10132-3.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=f8d8a7a182c0854fa50d3976077b3a3d8de8980f";
      sha256 = "08306952a32khl8mkw1xarh084dqp9vxhl6hwm2cmf30zkp8jlff";
    })
  ] ++ optionals (!stdenv.isDarwin) [  # this patch appears to be broken on darwin
    (fetchpatch {
      name = "4.10.0-CVE-2019-10161.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=3572564893d1710beb1862797fe32cc2e9cb1e38";
      sha256 = "118541d8w1jg92kqzrjhf631f753wncx6xm64jwzhnc096l7swsj";
    })
  ] ++ [
    (fetchpatch {
      name = "4.10.0-CVE-2019-10166.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=3f744efec31959f7643849f6a3708198bcdfc6ae";
      sha256 = "0alkw14iwcdy32r6g2lm660ss6fax9c1d9l53s5788vkjfw3jnz0";
    })
    (fetchpatch {
      name = "4.10.0-CVE-2019-10167.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=d238f132e6e0432a42d3cdff4571730dae3a85eb";
      sha256 = "0pnvzdhdiqd4hvc5ip59iszahkfrwvf7f99p2v2lb438z9c5bb32";
    })
    (fetchpatch {
      name = "4.10.0-CVE-2019-10168.patch";
      url = "https://libvirt.org/git/?p=libvirt.git;a=patch;h=09c2635d0deec198de0f250abc2958f2d1c09eaa";
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
