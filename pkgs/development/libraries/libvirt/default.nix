{ lib
, autoreconfHook
, bash-completion
, bridge-utils
, cmake
, coreutils
, curl
, darwin
, dbus
, dnsmasq
, docutils
, fetchFromGitLab
, fetchurl
, gettext
, glib
, gnutls
, iproute2
, iptables
, libgcrypt
, libpcap
, libtasn1
, libxml2
, libxslt
, makeWrapper
, meson
, ninja
, perl
, perlPackages
, pkg-config
, pmutils
, python3
, readline
, rpcsvc-proto
, stdenv
, xhtml1
, yajl

  # Linux
, acl ? null
, attr ? null
, audit ? null
, dmidecode ? null
, fuse ? null
, kmod ? null
, libapparmor ? null
, libcap_ng ? null
, libnl ? null
, libpciaccess ? null
, libtirpc ? null
, lvm2 ? null
, numactl ? null
, numad ? null
, parted ? null
, systemd ? null
, util-linux ? null

  # Darwin
, gmp ? null
, libiconv ? null
, Carbon ? null
, AppKit ? null

  # Options
, enableCeph ? false
, ceph ? null
, enableGlusterfs ? false
, glusterfs ? null
, enableIscsi ? false
, openiscsi ? null
, libiscsi ? null
, enableXen ? false
, xen ? null
, enableZfs ? stdenv.isLinux
, zfs ? null
}:

with lib;

let
  inherit (stdenv) isDarwin isLinux isx86_64;
  binPath = makeBinPath ([
    dnsmasq
  ] ++ optionals isLinux [
    bridge-utils
    dmidecode
    dnsmasq
    iproute2
    iptables
    kmod
    lvm2
    numactl
    numad
    pmutils
    systemd
  ] ++ optionals enableIscsi [
    libiscsi
    openiscsi
  ]);
in

assert enableXen -> isLinux && isx86_64;
assert enableCeph -> isLinux;
assert enableGlusterfs -> isLinux;
assert enableZfs -> isLinux;

# if you update, also bump <nixpkgs/pkgs/development/python-modules/libvirt/default.nix> and SysVirt in <nixpkgs/pkgs/top-level/perl-packages.nix>
stdenv.mkDerivation rec {
  pname = "libvirt";
  # NOTE: You must also bump:
  # <nixpkgs/pkgs/development/python-modules/libvirt/default.nix>
  # SysVirt in <nixpkgs/pkgs/top-level/perl-packages.nix>
  version = "7.10.0";

  src =
    if isDarwin then
      fetchurl
        {
          url = "https://libvirt.org/sources/${pname}-${version}.tar.xz";
          sha256 = "sha256-yzGAFK8JcyeSjG49cpIuO+AqPmQBJHsqpS2auOC0gPk=";
        }
    else
      fetchFromGitLab
        {
          owner = pname;
          repo = pname;
          rev = "v${version}";
          sha256 = "sha256-bB8LsjZFeJbMmmC0YRPyMag2MBhwagUFC7aB1KhZEkA=";
          fetchSubmodules = true;
        };

  patches = [
    ./0001-meson-patch-in-an-install-prefix-for-building-on-nix.patch
  ];

  # remove some broken tests
  postPatch = ''
    sed -i '/commandtest/d' tests/meson.build
    sed -i '/virnetsockettest/d' tests/meson.build
    # delete only the first occurrence of this
    sed -i '0,/qemuxml2argvtest/{/qemuxml2argvtest/d;}' tests/meson.build
  '';


  nativeBuildInputs = [
    meson

    cmake
    docutils
    makeWrapper
    ninja
    pkg-config
  ]
  ++ optional (!isDarwin) rpcsvc-proto
  # NOTE: needed for rpcgen
  ++ optional isDarwin darwin.developer_cmds;

  buildInputs = [
    bash-completion
    curl
    dbus
    gettext
    glib
    gnutls
    libgcrypt
    libpcap
    libtasn1
    libxml2
    libxslt
    perl
    perlPackages.XMLXPath
    pkg-config
    python3
    readline
    xhtml1
    yajl
  ] ++ optionals isLinux [
    acl
    attr
    audit
    fuse
    libapparmor
    libcap_ng
    libnl
    libpciaccess
    libtirpc
    lvm2
    numactl
    numad
    parted
    systemd
    util-linux
  ] ++ optionals isDarwin [
    AppKit
    Carbon
    gmp
    libiconv
  ]
  ++ optionals enableCeph [ ceph ]
  ++ optionals enableGlusterfs [ glusterfs ]
  ++ optionals enableIscsi [ libiscsi openiscsi ]
  ++ optionals enableXen [ xen ]
  ++ optionals enableZfs [ zfs ];

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
      PATH="${binPath}:$PATH"
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
      cfg = option: val: "-D${option}=${val}";
      feat = option: enable: cfg option (if enable then "enabled" else "disabled");
      driver = name: feat "driver_${name}";
      storage = name: feat "storage_${name}";
    in
    [
      "--sysconfdir=/var/lib"
      (cfg "install_prefix" (placeholder "out"))
      (cfg "localstatedir" "/var")
      (cfg "runstatedir" "/run")

      (cfg "init_script" (if isDarwin then "none" else "systemd"))

      (feat "apparmor" isLinux)
      (feat "attr" isLinux)
      (feat "audit" isLinux)
      (feat "bash_completion" true)
      (feat "blkid" isLinux)
      (feat "capng" isLinux)
      (feat "curl" true)
      (feat "docs" true)
      (feat "expensive_tests" true)
      (feat "firewalld" isLinux)
      (feat "firewalld_zone" isLinux)
      (feat "fuse" isLinux)
      (feat "glusterfs" enableGlusterfs)
      (feat "host_validate" true)
      (feat "libiscsi" enableIscsi)
      (feat "libnl" isLinux)
      (feat "libpcap" true)
      (feat "libssh2" true)
      (feat "login_shell" isLinux)
      (feat "nss" isLinux)
      (feat "numactl" isLinux)
      (feat "numad" isLinux)
      (feat "pciaccess" isLinux)
      (feat "polkit" true)
      (feat "readline" true)
      (feat "secdriver_apparmor" isLinux)
      (feat "tests" true)
      (feat "udev" isLinux)
      (feat "yajl" true)

      (driver "ch" isLinux)
      (driver "esx" true)
      (driver "interface" isLinux)
      (driver "libvirtd" true)
      (driver "libxl" enableXen)
      (driver "lxc" isLinux)
      (driver "network" true)
      (driver "openvz" isLinux)
      (driver "qemu" true)
      (driver "remote" true)
      (driver "secrets" true)
      (driver "test" true)
      (driver "vbox" true)
      (driver "vmware" true)

      (storage "dir" true)
      (storage "disk" isLinux)
      (storage "fs" isLinux)
      (storage "gluster" enableGlusterfs)
      (storage "iscsi" enableIscsi)
      (storage "iscsi_direct" enableIscsi)
      (storage "lvm" isLinux)
      (storage "mpath" isLinux)
      (storage "rbd" enableCeph)
      (storage "scsi" true)
      (storage "vstorage" isLinux)
      (storage "zfs" enableZfs)
    ];

  doCheck = true;

  postInstall = ''
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
  '' + optionalString isLinux ''
    substituteInPlace $out/lib/systemd/system/libvirtd.service --replace /bin/kill ${coreutils}/bin/kill
    rm $out/lib/systemd/system/{virtlockd,virtlogd}.*
    wrapProgram $out/sbin/libvirtd \
      --prefix PATH : /run/libvirt/nix-emulators:${binPath}
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
    maintainers = with maintainers; [ fpletz globin lovesegfault ];
  };
}
