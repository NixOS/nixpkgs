{ lib
, stdenv
, fetchurl
, fetchFromGitLab
, makeWrapper
, autoreconfHook
, fetchpatch
, coreutils
, libxml2
, gnutls
, perl
, python3
, attr
, glib
, docutils
, iproute2
, readline
, lvm2
, util-linux
, systemd
, libpciaccess
, gettext
, libtasn1
, iptables
, libgcrypt
, yajl
, pmutils
, libcap_ng
, libapparmor
, dnsmasq
, libnl
, libpcap
, libxslt
, xhtml1
, numad
, numactl
, perlPackages
, curl
, parted
, bridge-utils
, dmidecode
, dbus
, libtirpc
, rpcsvc-proto
, darwin
, meson
, ninja
, audit
, cmake
, bash-completion
, pkg-config
, enableCeph ? false, ceph ? null
, enableGlusterfs ? false, glusterfs ? null
, enableIscsi ? false, openiscsi ? null
, enableXen ? false, xen ? null
, enableZfs ? true, zfs ? null
# Darwin
, gmp
, libiconv
, Carbon ? null
, AppKit ? null
}:

with lib;

assert enableXen -> stdenv.isLinux && stdenv.isx86_64;
assert enableCeph -> stdenv.isLinux;
assert enableGlusterfs -> stdenv.isLinux;
assert enableZfs -> stdenv.isLinux;

# if you update, also bump <nixpkgs/pkgs/development/python-modules/libvirt/default.nix> and SysVirt in <nixpkgs/pkgs/top-level/perl-packages.nix>
let
  buildFromTarball = stdenv.isDarwin;
in
stdenv.mkDerivation rec {
  pname = "libvirt";
  version = "8.1.0";

  src =
    if buildFromTarball then
      fetchurl
        {
          url = "https://libvirt.org/sources/${pname}-${version}.tar.xz";
          sha256 = "sha256-PGxDvs/+s0o/OXxhYgaqaaiT/4v16CCDk8hOjnU1KTQ=";
        }
    else
      fetchFromGitLab
        {
          owner = pname;
          repo = pname;
          rev = "v${version}";
          sha256 = "sha256-nk8pBlss+g4EMy+RnAOyz6YlGGvlBvl5aBpcytsK1wY=";
          fetchSubmodules = true;
        };

  patches = [
    ./do-not-use-sysconfig.patch
    ./qemu-segmentation-fault-in-virtqemud-executing-qemuD.patch
  ];

  nativeBuildInputs = [
    ninja
    meson
    cmake
    makeWrapper
    pkg-config
    docutils
  ] ++ optional (!stdenv.isDarwin) [
    rpcsvc-proto
  ] ++ optionals stdenv.isDarwin [
    darwin.developer_cmds # needed for rpcgen
  ];

  buildInputs = [
    bash-completion
    pkg-config
    libxml2
    gnutls
    perl
    python3
    readline
    gettext
    libtasn1
    libgcrypt
    yajl
    libxslt
    xhtml1
    perlPackages.XMLXPath
    curl
    libpcap
    glib
    dbus
  ] ++ optionals stdenv.isLinux [
    audit
    libpciaccess
    lvm2
    util-linux
    systemd
    libnl
    numad
    libapparmor
    libcap_ng
    numactl
    attr
    parted
    libtirpc
  ] ++ optionals enableCeph [
    ceph
  ] ++ optionals enableGlusterfs [
    glusterfs
  ] ++ optionals enableIscsi [
    openiscsi
  ] ++ optionals enableXen [
    xen
  ] ++ optionals enableZfs [
    zfs
  ] ++ optionals stdenv.isDarwin [
    libiconv
    gmp
    Carbon
    AppKit
  ];

  preConfigure =
    let
      overrides = {
        QEMU_BRIDGE_HELPER = "/run/wrappers/bin/qemu-bridge-helper";
        QEMU_PR_HELPER = "/run/libvirt/nix-helpers/qemu-pr-helper";
      };
      patchBuilder = var: value: ''
        sed -i meson.build -e "s|conf.set_quoted('${var}',.*|conf.set_quoted('${var}','${value}')|"
      '';
    in
    ''
      PATH=${lib.makeBinPath ([ dnsmasq ] ++ optionals stdenv.isLinux [ iproute2 iptables lvm2 systemd numad ] ++ optionals enableIscsi [ openiscsi ])}:$PATH
      # the path to qemu-kvm will be stored in VM's .xml and .save files
      # do not use "''${qemu_kvm}/bin/qemu-kvm" to avoid bound VMs to particular qemu derivations
      substituteInPlace src/lxc/lxc_conf.c \
        --replace 'lxc_path,' '"/run/libvirt/nix-emulators/libvirt_lxc",'
      substituteInPlace build-aux/meson.build \
        --replace "gsed" "sed" \
        --replace "gmake" "make" \
        --replace "ggrep" "grep"
      patchShebangs .
    ''
    + (lib.concatStringsSep "\n" (lib.mapAttrsToList patchBuilder overrides));

  mesonAutoFeatures = "auto";

  mesonFlags =
    let
      opt = option: enable: "-D${option}=${if enable then "enabled" else "disabled"}";
      enableDrivers = map (name: opt "driver_${name}" true);
    in
    [
      "--localstatedir=${placeholder "out"}/var/"
      "-Drunstatedir=${placeholder "out"}/run/"
      "-Dlibpcap=enabled"
      "-Dpolkit=enabled"
      (opt "storage_iscsi" enableIscsi)
    ] ++ optionals stdenv.isLinux [
      "-Dattr=enabled"
      "-Dapparmor=enabled"
      "-Dsecdriver_apparmor=enabled"
      "-Dnumad=enabled"
      "-Dstorage_disk=enabled"
      (opt "glusterfs" enableGlusterfs)
      (opt "storage_rbd" enableCeph)
      (opt "storage_zfs" enableZfs)
    ] ++ optionals stdenv.isDarwin [
      "-Dinit_script=none"
    ] ++ (enableDrivers [
      "ch"
      "esx"
      "interface"
      "libvirtd"
      "lxc"
      "network"
      "openvz"
      "qemu"
      "remote"
      "secrets"
      "test"
      "vbox"
      "vmware"
    ] ++ lib.optional enableXen "libxl");

  postInstall =
    let
      binPath = [ iptables iproute2 pmutils numad numactl bridge-utils dmidecode dnsmasq ] ++ optionals enableIscsi [ openiscsi ];
    in
    ''
      substituteInPlace $out/bin/virt-xml-validate \
        --replace xmllint ${libxml2}/bin/xmllint

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
