{
  lib,
  stdenv,
  testers,
  fetchgit,
  fetchpatch,

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
  systemdMinimal,
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
  bridge-utils,
  coreutils,
  diffutils,
  gawk,
  gnugrep,
  gnused,
  inetutils,
  iproute2,
  iptables,
  multipath-tools,
  nbd,
  openvswitch,
  util-linux,
  which,
}:

let
  inherit (lib)
    enableFeature
    getExe'
    licenses
    makeSearchPathOutput
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

  #TODO: fix paths instead.
  scriptEnvPath = makeSearchPathOutput "out" "bin" [
    bridge-utils
    coreutils
    diffutils
    gawk
    gnugrep
    gnused
    inetutils
    iproute2
    iptables
    multipath-tools
    nbd
    openvswitch
    perl
    util-linux.bin
    which
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "xen";
  version = "4.20.0";

  # This attribute can be overriden to correct the file paths in
  # `passthru` when building an unstable Xen.
  upstreamVersion = finalAttrs.version;
  # Useful for further identifying downstream Xen variants. (i.e. Qubes)
  vendor = "nixos";

  patches = [
    # XSA #469
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-01.patch";
      hash = "sha256-go743oBhYDuxsK0Xc6nK/WxutQQwc2ERtLKhCU9Dnng=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-02.patch";
      hash = "sha256-FTtEGAPFYxsun38hLhVMKJ1TFJOsTMK3WWPkO0R/OHg=sha256-FTtEGAPFYxsun38hLhVMKJ1TFJOsTMK3WWPkO0R/OHg=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-03.patch";
      hash = "sha256-UkYMSpUgFvr4GJPXLgQsCyppGkNbeiFMyCZORK5tfmA=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-04.patch";
      hash = "sha256-lpiDPSHi+v2VfaWE9kp4+hveZKTzojD1F+RHsOtKE3A=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-05.patch";
      hash = "sha256-N+WR8S5w9dLISlOhMI71TOH8jvCgVAR8xm310k3ZA/M=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-06.patch";
      hash = "sha256-ePuyB3VP9NfQbW36BP3jjMMHKJWFJGeTYUYZqy+IlHQ=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa469/xsa469-4.20-07.patch";
      hash = "sha256-+BsCJa01R2lrbu7tEluGrYSAqu2jJcrpFNUoLMY466c=";
    })
    (fetchpatch {
      url = "https://xenbits.xenproject.org/xsa/xsa470.patch";
      hash = "sha256-zhMZ6pCZtt0ocgsMFVqthMaof46lMMTaYmlepMXVJqM=";
    })
  ];

  outputs = [
    "out"
    "man"
    "doc"
    "dev"
    "boot"
  ];

  src = fetchgit {
    url = "https://xenbits.xenproject.org/git-http/xen.git";
    rev = "3ad5d648cda5add395f49fc3704b2552aae734f7";
    hash = "sha256-v2DRJv+1bym8zAgU74lo1HQ/9rUcyK3qc4Eec4RpcEY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    bison
    cmake
    flex
    pandoc
    pkg-config
    python3Packages.setuptools
  ];
  buildInputs =
    [
      # Xen
      acpica-tools
      bzip2
      dev86
      e2fsprogs.dev
      libnl
      libuuid
      lzo
      ncurses
      perl
      python3Packages.python
      xz
      yajl
      zlib
      zstd

      # oxenstored
      ocamlPackages.findlib
      ocamlPackages.ocaml

      # Python Fixes
      python3Packages.wrapPython
    ]
    ++ optionals withFlask [ checkpolicy ]
    ++ optionals (versionOlder finalAttrs.version "4.19") [ systemdMinimal ];

  configureFlags = [
    "--enable-systemd"
    "--disable-qemu-traditional"
    "--with-system-qemu"
    (if withSeaBIOS then "--with-system-seabios=${seabios-qemu.firmware}" else "--disable-seabios")
    (if withOVMF then "--with-system-ovmf=${OVMF.mergedFirmware}" else "--disable-ovmf")
    (if withIPXE then "--with-system-ipxe=${ipxe.firmware}" else "--disable-ipxe")
    (enableFeature withFlask "xsmpolicy")
  ];

  makeFlags =
    [
      "SUBSYSTEMS=${toString finalAttrs.buildFlags}"

      "PREFIX=$(out)"
      "BASH_COMPLETION_DIR=$(PREFIX)/share/bash-completion/completions"

      "XEN_WHOAMI=${finalAttrs.pname}"
      "XEN_DOMAIN=${finalAttrs.vendor}"

      "GIT=${coreutils}/bin/false"
      "WGET=${coreutils}/bin/false"
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
  prePatch = "rm --recursive --force tools/qemu-xen tools/qemu-xen-traditional";

  postPatch =
    # The following patch forces Xen to install xen.efi on $out/boot
    # instead of $out/boot/efi/efi/nixos, as the latter directory
    # would otherwise need to be created manually. This also creates
    # a more consistent output for downstreams who override the
    # vendor attribute above.
    ''
      substituteInPlace xen/Makefile \
        --replace-fail "\$(D)\$(EFI_MOUNTPOINT)/efi/\$(EFI_VENDOR)/\$(T)-\$(XEN_FULLVERSION).efi" \
                  "\$(D)\$(BOOT_DIR)/\$(T)-\$(XEN_FULLVERSION).efi"
    ''

    # The following patch fixes the call to /bin/mkdir on the
    # launch_xenstore.sh helper script.
    + ''
      substituteInPlace tools/hotplug/Linux/launch-xenstore.in \
        --replace-fail "/bin/mkdir" "${coreutils}/bin/mkdir"
    ''

    # The following expression fixes the paths called by Xen's systemd
    # units, so we can use them in the NixOS module.
    + ''
      substituteInPlace \
        tools/hotplug/Linux/systemd/{xen-init-dom0,xen-qemu-dom0-disk-backend,xenconsoled,xendomains,xenstored}.service.in \
        --replace-fail /bin/grep ${gnugrep}/bin/grep
      substituteInPlace \
       tools/hotplug/Linux/systemd/{xen-qemu-dom0-disk-backend,xenconsoled}.service.in \
        --replace-fail "/bin/mkdir" "${coreutils}/bin/mkdir"
    '';

  installPhase = ''
    runHook preInstall

    mkdir --parents $out $out/share $boot
    cp -prvd dist/install/nix/store/*/* $out/
    cp -prvd dist/install/etc $out
    cp -prvd dist/install/boot $boot

    runHook postInstall
  '';

  postInstall =
    # Wrap xencov_split, xenmon and xentrace_format.
    ''
      wrapPythonPrograms
    ''

    # We also need to wrap pygrub, which lies in $out/libexec/xen/bin.
    + ''
      wrapPythonProgramsIn "$out/libexec/xen/bin" "$out $pythonPath"
    ''

    # Fix shebangs in Xen's various scripts.
    #TODO: Remove any and all usage of `sed` and replace these complicated magic runes with readable code.
    + ''
      shopt -s extglob
      for i in $out/etc/xen/scripts/!(*.sh); do
        sed --in-place "2s@^@export PATH=$out/bin:${scriptEnvPath}\n@" $i
      done
    '';

  postFixup =
    ''
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
    longDescription =
      ''
        The Xen Project Hypervisor is a virtualisation technology defined as a *type-1
        hypervisor*, which allows multiple virtual machines, known as domains, to run
        concurrently with the host on the physical machine. On a typical *type-2
        hypervisor*, the virtual machines run as applications on top of the
        host. NixOS runs as the privileged **Domain 0**, and can paravirtualise or fully
        virtualise **Unprivileged Domains**.

        Use with the `qemu_xen` package.
      ''
      + "\nIncludes:\n* `xen.efi`: The Xen Project's [EFI binary](https://xenbits.xenproject.org/docs/${finalAttrs.meta.branch}-testing/misc/efi.html), available on the `boot` output of this package."
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
