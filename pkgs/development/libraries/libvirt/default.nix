{ lib
, bash
, bash-completion
, bridge-utils
, coreutils
, curl
, darwin
, dbus
, dnsmasq
, docutils
, fetchFromGitLab
, fetchpatch
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
, openssh
, perl
, perlPackages
, polkit
, pkg-config
, pmutils
, python3
, readline
, rpcsvc-proto
, stdenv
, substituteAll
, xhtml1
, yajl
, writeScript
, nixosTests

  # Linux
, acl ? null
, attr ? null
, audit ? null
, dmidecode ? null
, fuse3 ? null
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
, gmp
, libiconv
, qemu
, Carbon
, AppKit

  # Options
, enableCeph ? false
, ceph
, enableGlusterfs ? false
, glusterfs
, enableIscsi ? false
, openiscsi
, libiscsi
, enableXen ? false
, xen
, enableZfs ? stdenv.isLinux
, zfs
}:

let
  inherit (stdenv) isDarwin isLinux isx86_64;
  binPath = lib.makeBinPath ([
    dnsmasq
  ] ++ lib.optionals isLinux [
    bridge-utils
    dmidecode
    dnsmasq
    iproute2
    iptables
    kmod
    lvm2
    numactl
    numad
    openssh
    pmutils
    systemd
  ] ++ lib.optionals enableIscsi [
    libiscsi
    openiscsi
  ] ++ lib.optionals enableZfs [
    zfs
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
  version = "9.9.0";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8Tmn99wDkRoA+pnOjeCzHoCeR3P3MwCA1kqY6SZpkqw=";
    fetchSubmodules = true;
  };

  patches = [
    ./0001-meson-patch-in-an-install-prefix-for-building-on-nix.patch
    (fetchpatch {
      name = "CVE-2024-2494.patch";
      url = "https://gitlab.com/libvirt/libvirt/-/commit/8a3f8d957507c1f8223fdcf25a3ff885b15557f2.patch";
      hash = "sha256-kxSIZ4bPOhN6PpJepoSF+EDTgdmazRWh3a3KSVfm1GU=";
    })
    (fetchpatch {
      name = "CVE-2024-1441.patch";
      url = "https://gitlab.com/libvirt/libvirt/-/commit/c664015fe3a7bf59db26686e9ed69af011c6ebb8.patch";
      hash = "sha256-Qi/gk7+NPz9s9OpWOnF8XW6A75C9BbVxBTE4KVwalo4=";
    })
  ] ++ lib.optionals enableZfs [
    (substituteAll {
      src = ./0002-substitute-zfs-and-zpool-commands.patch;
      zfs = "${zfs}/bin/zfs";
      zpool = "${zfs}/bin/zpool";
    })
  ];

  # remove some broken tests
  postPatch = ''
    sed -i '/commandtest/d' tests/meson.build
    sed -i '/virnetsockettest/d' tests/meson.build
    # delete only the first occurrence of this
    sed -i '0,/qemuxml2argvtest/{/qemuxml2argvtest/d;}' tests/meson.build

  '' + lib.optionalString isLinux ''
    for binary in mount umount mkfs; do
      substituteInPlace meson.build \
        --replace "find_program('$binary'" "find_program('${lib.getBin util-linux}/bin/$binary'"
    done

  '' + ''
    substituteInPlace meson.build \
      --replace "'dbus-daemon'," "'${lib.getBin dbus}/bin/dbus-daemon',"
  '' + lib.optionalString isLinux ''
    sed -i 's,define PARTED "parted",define PARTED "${parted}/bin/parted",' \
      src/storage/storage_backend_disk.c \
      src/storage/storage_util.c
  '' + lib.optionalString isDarwin ''
    # Darwin doesn’t support -fsemantic-interposition, but the problem doesn’t seem to affect Mach-O.
    # See https://gitlab.com/libvirt/libvirt/-/merge_requests/235
    sed -i "s/not supported_cc_flags.contains('-fsemantic-interposition')/false/" meson.build
    sed -i '/qemufirmwaretest/d' tests/meson.build
    sed -i '/qemuvhostusertest/d' tests/meson.build
    sed -i '/qemuxml2xmltest/d' tests/meson.build
  '';

  strictDeps = true;

  nativeBuildInputs = [
    meson
    docutils
    libxml2 # for xmllint
    libxslt # for xsltproc
    gettext
    makeWrapper
    ninja
    pkg-config
    perl
    perlPackages.XMLXPath
  ]
  ++ lib.optional (!isDarwin) rpcsvc-proto
  # NOTE: needed for rpcgen
  ++ lib.optional isDarwin darwin.developer_cmds;

  buildInputs = [
    bash
    bash-completion
    curl
    dbus
    glib
    gnutls
    libgcrypt
    libpcap
    libtasn1
    libxml2
    python3
    readline
    xhtml1
    yajl
  ] ++ lib.optionals isLinux [
    acl
    attr
    audit
    fuse3
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
  ] ++ lib.optionals isDarwin [
    AppKit
    Carbon
    gmp
    libiconv
  ]
  ++ lib.optionals enableCeph [ ceph ]
  ++ lib.optionals enableGlusterfs [ glusterfs ]
  ++ lib.optionals enableIscsi [ libiscsi openiscsi ]
  ++ lib.optionals enableXen [ xen ]
  ++ lib.optionals enableZfs [ zfs ];

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

      substituteInPlace src/util/virpolkit.h \
        --replace '"/usr/bin/pkttyagent"' '"${if isLinux then polkit.bin else "/usr"}/bin/pkttyagent"'

      patchShebangs .
    ''
    + (lib.concatStringsSep "\n" (lib.mapAttrsToList patchBuilder overrides));

  mesonAutoFeatures = "disabled";

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
      (cfg "qemu_datadir" (lib.optionalString isDarwin "${qemu}/share/qemu"))

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
      (feat "nss" (isLinux && !stdenv.hostPlatform.isMusl))
      (feat "numactl" isLinux)
      (feat "numad" isLinux)
      (feat "pciaccess" isLinux)
      (feat "polkit" isLinux)
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
      --replace 'PARALLEL_SHUTDOWN=0'   'PARALLEL_SHUTDOWN=''${PARALLEL_SHUTDOWN:-0}' \
      --replace "$out/bin"              '${gettext}/bin' \
      --replace 'lock/subsys'           'lock' \
      --replace 'gettext.sh'            'gettext.sh
    # Added in nixpkgs:
    gettext() { "${gettext}/bin/gettext" "$@"; }
    '
  '' + lib.optionalString isLinux ''
    for f in $out/lib/systemd/system/*.service ; do
      substituteInPlace $f --replace /bin/kill ${coreutils}/bin/kill
    done
    rm $out/lib/systemd/system/{virtlockd,virtlogd}.*
    wrapProgram $out/sbin/libvirtd \
      --prefix PATH : /run/libvirt/nix-emulators:${binPath}
  '';

  passthru.updateScript = writeScript "update-libvirt" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts

    set -eu -o pipefail

    libvirtVersion=$(curl https://gitlab.com/api/v4/projects/192693/repository/tags | jq -r '.[].name|select(. | contains("rc") | not)' | head -n1 | sed "s/v//g")
    sysvirtVersion=$(curl https://gitlab.com/api/v4/projects/192677/repository/tags | jq -r '.[].name|select(. | contains("rc") | not)' | head -n1 | sed "s/v//g")
    update-source-version ${pname} "$libvirtVersion"
    update-source-version python3Packages.${pname} "$libvirtVersion"
    update-source-version perlPackages.SysVirt "$sysvirtVersion" --file="pkgs/top-level/perl-packages.nix"
  '';

  passthru.tests.libvirtd = nixosTests.libvirtd;

  meta = with lib; {
    description = "A toolkit to interact with the virtualization capabilities of recent versions of Linux and other OSes";
    homepage = "https://libvirt.org/";
    changelog = "https://gitlab.com/libvirt/libvirt/-/raw/v${version}/NEWS.rst";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz globin lovesegfault ];
  };
}
