{ lib, stdenv, fetchurl, fetchgit
, makeWrapper, autoreconfHook, fetchpatch
, coreutils, libxml2, gnutls, perl, python3, attr, glib, docutils
, iproute, readline, lvm2, util-linux, systemd, libpciaccess, gettext
, libtasn1, iptables, ebtables, libgcrypt, yajl, pmutils, libcap_ng, libapparmor
, dnsmasq, libnl, libpcap, libxslt, xhtml1, numad, numactl, perlPackages
, curl, libiconv, gmp, zfs, parted, bridge-utils, dmidecode, dbus, libtirpc, rpcsvc-proto, darwin
, meson, ninja, audit, cmake, bash-completion, pkg-config
, enableXen ? false, xen ? null
, enableIscsi ? false, openiscsi
, enableCeph ? false, ceph
}:

with lib;

# if you update, also bump <nixpkgs/pkgs/development/python-modules/libvirt/default.nix> and SysVirt in <nixpkgs/pkgs/top-level/perl-packages.nix>
let
  buildFromTarball = stdenv.isDarwin;
  # libvirt hardcodes the binary name 'ebtables', but in nixpkgs the ebtables
  # binary we want to use is named 'ebtables-legacy'.
  # Create a derivation to alias the binary name so that libvirt can find the right one, and use that below.
  ebtables-compat = stdenv.mkDerivation {
    pname = "ebtables-compat";
    version = ebtables.version;
    src = null;
    buildInputs = [ ebtables ];
    buildCommand = ''
      mkdir -p $out/bin
      ln -sf ${ebtables}/bin/ebtables-legacy $out/bin/ebtables
    '';
  };
in stdenv.mkDerivation rec {
  pname = "libvirt";
  version = "7.0.0";

  src =
    if buildFromTarball then
      fetchurl {
        url = "https://libvirt.org/sources/${pname}-${version}.tar.xz";
        sha256 = "12fxkpy7j2qhfxypw9jg3bzdd9xx6vf6x96iy5kjihh89n236f6a";
      }
    else
      fetchgit {
        url = "https://gitlab.com/libvirt/libvirt.git";
        rev = "v${version}";
        sha256 = "0xg9d410008mny73r2cp5ipghqpk0gz9gy7j32vcfk691dq75b3c";
        fetchSubmodules = true;
      };

  patches = [
    ./0001-meson-patch-in-an-install-prefix-for-building-on-nix.patch
  ];

  nativeBuildInputs = [
    ninja meson cmake makeWrapper pkg-config docutils
  ] ++ optional (!stdenv.isDarwin) [
    rpcsvc-proto
  ] ++ optionals stdenv.isDarwin [
    darwin.developer_cmds # needed for rpcgen
  ];

  buildInputs = [
    bash-completion pkg-config
    libxml2 gnutls perl python3 readline gettext libtasn1 libgcrypt yajl
    libxslt xhtml1 perlPackages.XMLXPath curl libpcap glib dbus
  ] ++ optionals stdenv.isLinux [
    audit libpciaccess lvm2 util-linux systemd libnl numad zfs
    libapparmor libcap_ng numactl attr parted libtirpc
  ] ++ optionals (enableXen && stdenv.isLinux && stdenv.isx86_64) [
    xen
  ] ++ optionals enableIscsi [
    openiscsi
  ] ++ optionals enableCeph [
    ceph
  ] ++ optionals stdenv.isDarwin [
    libiconv gmp
  ];

  preConfigure = let
    overrides = {
      QEMU_BRIDGE_HELPER = "/run/wrappers/bin/qemu-bridge-helper";
      QEMU_PR_HELPER = "/run/libvirt/nix-helpers/qemu-pr-helper";
    };
    patchBuilder = var: value: ''
      sed -i meson.build -e "s|conf.set_quoted('${var}',.*|conf.set_quoted('${var}','${value}')|"
    '';
  in ''
    PATH=${lib.makeBinPath ([ dnsmasq ] ++ optionals stdenv.isLinux [ iproute iptables ebtables-compat lvm2 systemd numad ] ++ optionals enableIscsi [ openiscsi ])}:$PATH
    # the path to qemu-kvm will be stored in VM's .xml and .save files
    # do not use "''${qemu_kvm}/bin/qemu-kvm" to avoid bound VMs to particular qemu derivations
    substituteInPlace src/lxc/lxc_conf.c \
      --replace 'lxc_path,' '"/run/libvirt/nix-emulators/libvirt_lxc",'
    patchShebangs .
  ''
  + (lib.concatStringsSep "\n" (lib.mapAttrsToList patchBuilder overrides));

  mesonAutoFeatures = "auto";

  mesonFlags = let
    opt = option: enable: "-D${option}=${if enable then "enabled" else "disabled"}";
  in [
    "--sysconfdir=/var/lib"
    "-Dinstall_prefix=${placeholder "out"}"
    "-Dlocalstatedir=/var"
    "-Drunstatedir=/run"
    "-Dlibpcap=enabled"
    "-Ddriver_qemu=enabled"
    "-Ddriver_vmware=enabled"
    "-Ddriver_vbox=enabled"
    "-Ddriver_test=enabled"
    "-Ddriver_esx=enabled"
    "-Ddriver_remote=enabled"
    "-Dpolkit=enabled"
    (opt "storage_iscsi" enableIscsi)
  ] ++ optionals stdenv.isLinux [
    (opt "storage_zfs" (zfs != null))
    "-Dattr=enabled"
    "-Dapparmor=enabled"
    "-Dsecdriver_apparmor=enabled"
    "-Dnumad=enabled"
    "-Dstorage_disk=enabled"
    (opt "storage_rbd" enableCeph)
  ] ++ optionals stdenv.isDarwin [
    "-Dinit_script=none"
  ];

  postInstall = let
    # Keep the legacy iptables binary for now for backwards compatibility (comment on #109332)
    binPath = [ iptables ebtables-compat iproute pmutils numad numactl bridge-utils dmidecode dnsmasq ] ++ optionals enableIscsi [ openiscsi ];
  in ''
    substituteInPlace $out/libexec/libvirt-guests.sh \
      --replace 'ON_BOOT="start"'       'ON_BOOT=''${ON_BOOT:-start}' \
      --replace 'ON_SHUTDOWN="suspend"' 'ON_SHUTDOWN=''${ON_SHUTDOWN:-suspend}' \
      --replace "$out/bin"              '${gettext}/bin' \
      --replace 'lock/subsys'           'lock' \
      --replace 'gettext.sh'            'gettext.sh
  # Added in nixpkgs:
  gettext() { "${gettext}/bin/gettext" "$@"; }
  '
  '' + optionalString stdenv.isLinux ''
    substituteInPlace $out/lib/systemd/system/libvirtd.service --replace /bin/kill ${coreutils}/bin/kill
    rm $out/lib/systemd/system/{virtlockd,virtlogd}.*
    wrapProgram $out/sbin/libvirtd \
      --prefix PATH : /run/libvirt/nix-emulators:${makeBinPath binPath}
  '';

  meta = {
    homepage = "https://libvirt.org/";
    repositories.git = "git://libvirt.org/libvirt.git";
    description = ''
      A toolkit to interact with the virtualization capabilities of recent
      versions of Linux (and other OSes)
    '';
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz globin ];
  };
}
