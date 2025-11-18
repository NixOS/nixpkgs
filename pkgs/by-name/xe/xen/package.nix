{
  lib,
  stdenv,
  testers,
  fetchFromGitHub,
  fetchpatch,
  replaceVars,

  # Xen
  acpica-tools,
  autoPatchelfHook,
  binutils-unwrapped-all-targets,
  bison,
  bzip2,
  cmake,
  dev86,
  e2fsprogs,
  flex,
  libnl,
  libuuid,
  lzo,
  ncurses,
  ocamlPackages,
  perl,
  pkg-config,
  python3Packages,
  systemd,
  xz,
  yajl,
  zlib,
  zstd,

  # Optional Components
  withFlask ? false,
  checkpolicy,
  withIPXE ? true,
  ipxe,
  withOVMF ? true,
  OVMF,
  withSeaBIOS ? true,
  seabios-qemu,

  # Documentation
  pandoc,

  # Scripts
  bash,
  bridge-utils,
  coreutils,
  diffutils,
  drbd,
  gawk,
  gnugrep,
  gnused,
  inetutils,
  iproute2,
  iptables,
  kmod,
  multipath-tools,
  nbd,
  openiscsi,
  openvswitch,
  psmisc,
  util-linux,
  which,
}:

let
  inherit (lib)
    enableFeature
    genAttrs
    getExe
    getExe'
    licenses
    optionalString
    optionals
    systems
    teams
    versionOlder
    versions
    warn
    ;
  inherit (systems.inspect.patterns) isLinux isAarch64;
  inherit (licenses)
    cc-by-40
    gpl2Only
    lgpl21Only
    mit
    ;

  # Mark versions older than minSupportedVersion as EOL.
  minSupportedVersion = "4.17";

  scriptDeps =
    let
      mkTools = pkg: tools: genAttrs tools (tool: getExe' pkg tool);
    in
    (genAttrs [
      "CONFIG_DIR"
      "CONFIG_LEAF_DIR"
      "LIBEXEC_BIN"
      "XEN_LOG_DIR"
      "XEN_RUN_DIR"
      "XEN_SCRIPT_DIR"
      "qemu_xen_systemd"
      "sbindir"
    ] (_: null))
    // (mkTools coreutils [
      "basename"
      "cat"
      "cp"
      "cut"
      "dirname"
      "head"
      "ls"
      "mkdir"
      "mktemp"
      "readlink"
      "rm"
      "seq"
      "sleep"
      "stat"
    ])
    // (mkTools drbd [
      "drbdadm"
      "drbdsetup"
    ])
    // (mkTools gnugrep [
      "egrep"
      "grep"
    ])
    // (mkTools iproute2 [
      "bridge"
      "ip"
      "tc"
    ])
    // (mkTools iptables [
      "arptables"
      "ip6tables"
      "iptables"
    ])
    // (mkTools kmod [
      "modinfo"
      "modprobe"
      "rmmod"
    ])
    // (mkTools libnl [
      "nl-qdisc-add"
      "nl-qdisc-delete"
      "nl-qdisc-list"
    ])
    // (mkTools util-linux [
      "flock"
      "logger"
      "losetup"
      "prlimit"
    ])
    // {
      awk = getExe' gawk "awk";
      brctl = getExe bridge-utils;
      diff = getExe' diffutils "diff";
      ifconfig = getExe' inetutils "ifconfig";
      iscsiadm = getExe' openiscsi "iscsiadm";
      killall = getExe' psmisc "killall";
      multipath = getExe' multipath-tools "multipath";
      nbd-client = getExe' nbd "nbd-client";
      ovs-vsctl = getExe' openvswitch "ovs-vsctl";
      sed = getExe gnused;
      systemd-notify = getExe' systemd "systemd-notify";
      which = getExe which;
    };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "xen";
  version = "4.20.2";

  # This attribute can be overriden to correct the file paths in
  # `passthru` when building an unstable Xen.
  upstreamVersion = finalAttrs.version;
  # Useful for further identifying downstream Xen variants. (i.e. Qubes)
  vendor = "nixos";

  patches = [
    ./0001-makefile-efi-output-directory.patch

    (replaceVars ./0002-scripts-external-executable-calls.patch scriptDeps)

    # patch `libxl` to search for `qemu-system-i386` properly. (Before 4.21)
    (fetchpatch {
      url = "https://github.com/xen-project/xen/commit/f6281291704aa356489f4bd927cc7348a920bd01.diff?full_index=1";
      hash = "sha256-LH+68kxH/gxdyh45kYCPxKwk+9cztLrScpC2pCNQV2M=";
    })
  ];

  outputs = [
    "out"
    "man"
    "doc"
    "dev"
    "boot"
  ];

  src = fetchFromGitHub {
    owner = "xen-project";
    repo = "xen";
    tag = "RELEASE-4.20.2";
    hash = "sha256-ZDPjsEAEH5bW0156MVvOKUeqg+mwdce0GFdUTBH39Qc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    acpica-tools
    autoPatchelfHook
    bison
    cmake
    dev86
    flex
    pandoc
    perl
    pkg-config

    # oxenstored
    ocamlPackages.findlib
    ocamlPackages.ocaml
  ]
  ++ (with python3Packages; [
    python
    setuptools
    wrapPython
  ]);

  buildInputs = [
    bash
    bzip2
    e2fsprogs.dev
    libnl
    libuuid
    lzo
    ncurses
    xz
    yajl
    zlib
    zstd
  ]
  ++ optionals withFlask [ checkpolicy ]
  ++ optionals (versionOlder finalAttrs.version "4.19") [ systemd ];

  configureFlags = [
    "--enable-systemd"
    "--disable-qemu-traditional"
    "--with-system-qemu"
    (if withSeaBIOS then "--with-system-seabios=${seabios-qemu.firmware}" else "--disable-seabios")
    (if withOVMF then "--with-system-ovmf=${OVMF.mergedFirmware}" else "--disable-ovmf")
    (if withIPXE then "--with-system-ipxe=${ipxe.firmware}" else "--disable-ipxe")
    (enableFeature withFlask "xsmpolicy")
  ];

  makeFlags = [
    "SUBSYSTEMS=${toString finalAttrs.buildFlags}"

    "PREFIX=$(out)"
    "BASH_COMPLETION_DIR=$(PREFIX)/share/bash-completion/completions"

    "XEN_WHOAMI=${finalAttrs.pname}"
    "XEN_DOMAIN=${finalAttrs.vendor}"

    "GIT=${getExe' coreutils "false"}"
    "WGET=${getExe' coreutils "false"}"
    "EFI_VENDOR=${finalAttrs.vendor}"
    "INSTALL_EFI_STRIP=1"
    "LD=${getExe' binutils-unwrapped-all-targets "ld"}"
  ]
  # These flags set the CONFIG_* options in /boot/xen.config
  # and define if the default policy file is built. However,
  # the Flask binaries always get compiled by default.
  ++ optionals withFlask [
    "XSM_ENABLE=y"
    "FLASK_ENABLE=y"
  ];

  buildFlags = [
    "xen"
    "tools"
    "docs"
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=maybe-uninitialized"
    "-Wno-error=array-bounds"
  ];

  dontUseCmakeConfigure = true;

  # Remove in-tree QEMU sources, we don't need them in any circumstance.
  prePatch = "rm -rf tools/qemu-xen tools/qemu-xen-traditional";

  installPhase = ''
    runHook preInstall

    mkdir -p $out $out/share $boot
    cp -prvd dist/install/nix/store/*/* $out/
    cp -prvd dist/install/etc $out
    # Decompresses the multiboot binary so it's present for bootloaders such as Limine
    # The find command is used instead of a simple file glob so we skip processing symlinks
    find dist/install/boot -type f -name '*.gz' -print -exec gunzip -k '{}' ';'
    cp -prvd dist/install/boot $boot

    runHook postInstall
  '';

  postInstall =
    # Wrap xencov_split, xenmon and xentrace_format.
    # We also need to wrap pygrub, which lies in $out/libexec/xen/bin.
    ''
      wrapPythonPrograms
      wrapPythonProgramsIn "$out/libexec/xen/bin" "$out $pythonPath"
    '';

  postFixup = ''
    addAutoPatchelfSearchPath $out/lib
    autoPatchelf $out/libexec/xen/bin
  ''
  # Flask is particularly hard to disable. Even after
  # setting the make flags to `n`, it still gets compiled.
  # If withFlask is disabled, delete the extra binaries.
  + optionalString (!withFlask) ''
    rm -f $out/bin/flask-*
  '';

  passthru = {
    efi = "boot/xen-${finalAttrs.upstreamVersion}.efi";
    multiboot = "boot/xen-${finalAttrs.upstreamVersion}";
    flaskPolicy =
      if withFlask then
        warn "This Xen was compiled with FLASK support, but the FLASK file may not match the Xen version number. Please hardcode the path to the FLASK file instead." "boot/xenpolicy-${finalAttrs.upstreamVersion}"
      else
        throw "This Xen was compiled without FLASK support.";
    # This test suite is very simple, as Xen's userspace
    # utilities require the hypervisor to be booted.
    tests = {
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        moduleNames = [
          "xencall"
          "xencontrol"
          "xendevicemodel"
          "xenevtchn"
          "xenforeignmemory"
          "xengnttab"
          "xenguest"
          "xenhypfs"
          "xenlight"
          "xenstat"
          "xenstore"
          "xentoolcore"
          "xentoollog"
          "xenvchan"
          "xlutil"
        ];
      };
    };
  };

  meta = {
    branch = versions.majorMinor finalAttrs.version;

    description = "Type-1 hypervisor intended for embedded and hyperscale use cases";
    longDescription = ''
      The Xen Project Hypervisor is a virtualisation technology defined as a *type-1
      hypervisor*, which allows multiple virtual machines, known as domains, to run
      concurrently with the host on the physical machine. On a typical *type-2
      hypervisor*, the virtual machines run as applications on top of the
      host. NixOS runs as the privileged **Domain 0**, and can paravirtualise or fully
      virtualise **Unprivileged Domains**.

      Use with the `qemu_xen` package.
    ''
    + "\nIncludes:\n* `xen-${finalAttrs.upstreamVersion}.efi`: The Xen Project's [EFI binary](https://xenbits.xenproject.org/docs/${finalAttrs.meta.branch}-testing/misc/efi.html), available on the `boot` output of this package."
    + "\n* `xen-${finalAttrs.upstreamVersion}`: The Xen Project's multiboot binary, available on the `boot` output of this package."
    + optionalString withFlask "\n* `xsm-flask`: The [FLASK Xen Security Module](https://wiki.xenproject.org/wiki/Xen_Security_Modules_:_XSM-FLASK). The `xenpolicy` file is available on the `boot` output of this package."
    + optionalString withSeaBIOS "\n* `seabios`: Support for the SeaBIOS boot firmware on HVM domains."
    + optionalString withOVMF "\n* `ovmf`: Support for the OVMF UEFI boot firmware on HVM domains."
    + optionalString withIPXE "\n* `ipxe`: Support for the iPXE boot firmware on HVM domains.";

    homepage = "https://xenproject.org/";
    downloadPage = "https://downloads.xenproject.org/release/xen/${finalAttrs.version}/";
    changelog = "https://wiki.xenproject.org/wiki/Xen_Project_${finalAttrs.meta.branch}_Release_Notes";

    license = [
      # Documentation.
      cc-by-40
      # Most of Xen is licensed under the GPL v2.0.
      gpl2Only
      # Xen Libraries and the `xl` command-line utility.
      lgpl21Only
      # Development headers in $dev/include.
      mit
    ];

    teams = [ teams.xen ];
    knownVulnerabilities = optionals (versionOlder finalAttrs.version minSupportedVersion) [
      "The Xen Project Hypervisor version ${finalAttrs.version} is no longer supported by the Xen Project Security Team. See https://xenbits.xenproject.org/docs/unstable/support-matrix.html"
    ];

    mainProgram = "xl";

    platforms = [ isLinux ];
    badPlatforms = [ isAarch64 ];
  };
})
