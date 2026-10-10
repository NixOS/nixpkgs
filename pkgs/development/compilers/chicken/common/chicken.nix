{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  fixDarwinDylibNames,
  darwin,
  replaceVars,
  testers,

  # Release-specific arguments, supplied by the per-release directory.
  version,
  hash,
  # The compiler's binary compatibility version, which is part of the egg
  # repository directory.
  binaryVersion,
  postPatch ? "",
  # When this is a cross chicken, the runtime it compiles against, and the
  # chicken that compiles its tools anew. Supplied by the package set, so that
  # they are overridden along with it.
  targetChicken,
  buildChicken,
}:

let
  # A "cross chicken" runs on the host platform but compiles code for the
  # target platform, against a CHICKEN runtime built for the target. See the
  # "Cross development" chapter of the manual.
  isCrossChicken = stdenv.targetPlatform != stdenv.hostPlatform;

  # The features CHICKEN derives from the machine it runs on, which a cross
  # chicken has to trade for the target's when compiling for it.
  machineFeatures = platform: [
    (
      if platform.isx86_64 then
        "x86-64"
      else if platform.isx86_32 then
        "x86"
      else if platform.isAarch64 then
        "arm64"
      else if platform.isAarch32 then
        "arm"
      else if platform.isRiscV64 then
        "riscv64"
      else if platform.isRiscV then
        "riscv"
      else if platform.isPower64 then
        "ppc64"
      else if platform.isPower then
        "ppc"
      else if platform.isMips then
        "mips"
      else
        "unknown"
    )
    "${toString platform.parsed.cpu.bits}bit"
    (if platform.isLittleEndian then "little-endian" else "big-endian")
  ];
  targetFeatures = lib.concatStringsSep " " (
    lib.concatLists (
      lib.zipListsWith (
        hostFeature: targetFeature:
        lib.optionals (hostFeature != targetFeature) [
          "-no-feature"
          hostFeature
          "-feature"
          targetFeature
        ]
      ) (machineFeatures stdenv.hostPlatform) (machineFeatures stdenv.targetPlatform)
    )
  );

  # What (software-version) evaluates to on the target platform.
  targetSoftwareVersion =
    with stdenv.targetPlatform;
    if isDarwin then
      "macosx"
    else if isLinux then
      "linux"
    else if isFreeBSD then
      "freebsd"
    else if isOpenBSD then
      "openbsd"
    else if isNetBSD then
      "netbsd"
    else if isCygwin then
      "cygwin"
    else if isMinGW then
      (if lib.versionAtLeast version "6" then "mingw" else "mingw32")
    else if isSunOS then
      "solaris"
    else
      "unknown";

  # CHICKEN 5 is R5RS with extensions; CHICKEN 6 targets R7RS.
  standard = if lib.versionAtLeast version "6" then "R7RS" else "R5RS";

  platform =
    with stdenv.hostPlatform;
    if isDarwin then
      "macosx"
    else if isCygwin then
      "cygwin"
    else if (isFreeBSD || isOpenBSD) then
      "bsd"
    else if isSunOS then
      "solaris"
    else
      "linux"; # Should be a sane default
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chicken";
  inherit version binaryVersion;

  # Lets chicken-install -target build eggs into Nix outputs:
  # - CHICKEN_INSTALL_PREFIX and CHICKEN_INSTALL_REPOSITORY are honored for the
  #   target, as for the host, instead of installing into the target's runtime.
  # - Dependencies are looked for among those the setup hook finds, not only
  #   in the repository of the target's runtime.
  # - Objects built for the target are not given a .target suffix, which the
  #   scripts do not use consistently: some pass objects with it to csc, which
  #   then does not take them for objects, and without it to ar.
  # The programs using these files are compiled anew below.
  ${if isCrossChicken then "patches" else null} = [
    ./cross-chicken-install-${lib.versions.major version}.patch
  ];

  # The target's libraries and data are assumed to be under TARGET_PREFIX, but
  # are in the lib output of the target's runtime, apart from its headers.
  postPatch =
    postPatch
    + lib.optionalString isCrossChicken ''
      substituteInPlace defaults.make \
        --replace-fail '$(TARGET_PREFIX)/lib' '$(TARGET_LIBDIR)' \
        --replace-fail '$(TARGET_PREFIX)/share/chicken' '$(TARGET_DATADIR)'

      # When linking statically for the target, csc looks for the objects of
      # eggs only in the repository of the target's runtime, where they are
      # not. It is made to look in those the setup hook finds among the
      # dependencies, too, and is then compiled anew by the native chicken.
      substituteInPlace csc.scm --replace-fail \
        "(destination-repository 'target)))" \
        "(cons (destination-repository 'target) (##sys#split-path (or (get-environment-variable \"NIX_CHICKEN_TARGET_REPOSITORY_PATH\") \"\")))))"

      # csc chooses how to compile and link, such as whether to make Mach-O
      # bundles or ELF objects with an rpath, by the system it runs on, which
      # is only right when compiling for the host.
      substituteInPlace csc.scm \
        --replace-fail "(software-version)" "(csc-software-version)" \
        --replace-fail "(define windows" "(define (csc-software-version)
        (if (or (not (feature? #:cross-chicken)) (member \"-host\" (command-line-arguments)))
            (software-version)
            '${targetSoftwareVersion}))
      (define windows"
      rm csc.c chicken-install.c chicken-uninstall.c chicken-status.c
    '';

  src = fetchurl {
    url = "https://code.call-cc.org/releases/${finalAttrs.version}/chicken-${finalAttrs.version}.tar.gz";
    inherit hash;
  };

  setupHook = replaceVars ./setup-hook.sh {
    binaryVersion = toString binaryVersion;
    # The compiler itself loads the eggs it compiles against, so a cross
    # chicken needs those built for the platform it runs on.
    compileTimeOffset = if isCrossChicken then "$hostOffset" else "$targetOffset";
  };

  # CHICKEN 5 has no configure script at all, and the one CHICKEN 6 ships is
  # hand-written rather than generated by autoconf: it only writes the make
  # variables below into "config.make" and rejects any option it does not know
  # about (including the ones stdenv would pass, such as --build and --bindir).
  # Command line variables take precedence over "config.make", so passing them
  # to make directly is equivalent and avoids fighting the generic configure
  # phase.
  dontConfigure = true;

  # Compiled programs link to libchicken, which records where the runtime's
  # repository and data are, so those go to the lib output, and programs refer
  # to that alone. The rest refers to the C compiler, by chicken-config.h.
  outputs = [
    "out"
    "lib"
  ];

  makeFlags = [
    "PLATFORM=${platform}"
    "PREFIX=$(out)"
    "LIBDIR=$(lib)/lib"
    "DATADIR=$(lib)/share/chicken"
    "DOCDIR=$(out)/share/chicken/doc"
    "C_COMPILER=$(CC)"
    "CXX_COMPILER=$(CXX)"
  ]
  # Otherwise libchicken.so is linked with -static, which cannot work.
  ++ lib.optional stdenv.hostPlatform.isStatic "STATICBUILD=1"
  ++ (lib.optionals stdenv.hostPlatform.isDarwin [
    "XCODE_TOOL_PATH=${darwin.binutils.bintools}/bin"
    "LINKER_OPTIONS=-headerpad_max_install_names"
    "POSTINSTALL_PROGRAM=install_name_tool"
  ])
  ++ (lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "HOSTSYSTEM=${stdenv.hostPlatform.config}"
    # Otherwise detected from the machine building it. The value is what
    # config-arch.sh reports on the host platform.
    "ARCH=${
      with stdenv.hostPlatform;
      if isx86_64 then
        "x86-64"
      else if isx86_32 then
        "x86"
      else if isPower && !isPower64 then
        (if isDarwin then "ppc.darwin" else "ppc.sysv")
      else if isRiscV then
        "riscv"
      else
        ""
    }"
  ])
  ++ (
    # The cross chicken is not given a PROGRAM_PREFIX, unlike in the manual,
    # as it loads the eggs it compiles against from the build platform's egg
    # set, which link to libchicken by its unprefixed soname: a prefix would
    # have them bring in a second runtime. Being alone in nativeBuildInputs, it
    # does not need one to set it apart from a native chicken.
    if isCrossChicken then
      [
        # Chosen from PATH when compiling, like the native C_COMPILER.
        "TARGETSYSTEM=${stdenv.targetPlatform.config}"
        "TARGET_C_COMPILER=${stdenv.targetPlatform.config}-cc"
        "TARGET_CXX_COMPILER=${stdenv.targetPlatform.config}-c++"
        "TARGET_LIBRARIAN=${stdenv.targetPlatform.config}-ar"
        "TARGET_PREFIX=${targetChicken}"
        "TARGET_LIBDIR=${lib.getLib targetChicken}/lib"
        "TARGET_DATADIR=${lib.getLib targetChicken}/share/chicken"
        # Where programs for the target find libchicken at run time.
        "TARGET_RUN_PREFIX=${lib.getLib targetChicken}"
        "TARGET_FEATURES=${targetFeatures}"
      ]
    else
      lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
        "TARGET_C_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
        "TARGET_CXX_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++"
      ]
  );

  nativeBuildInputs = [
    makeWrapper
  ]
  # To compile csc anew, which must be done by the same version of CHICKEN.
  ++ lib.optional isCrossChicken buildChicken
  # Upstream gives libchicken.dylib a bare install name and rewrites it only in
  # the programs it links, so programs linked to it otherwise cannot find it.
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    darwin.autoSignDarwinBinariesHook
  ];

  # The libraries to link programs for the target with depend on the target's
  # PLATFORM, so they are taken from the runtime built with it rather than
  # from the cross chicken's own, as the manual does for Windows.
  ${if isCrossChicken then "preBuild" else null} = ''
    makeFlags+=("TARGET_LIBRARIES=$(sed -n 's/^# define C_INSTALL_MORE_LIBS "\(.*\)"$/\1/p' \
      ${targetChicken}/include/chicken/chicken-config.h)")
  '';

  # The compiler loads the eggs it compiles against, built for the build
  # platform, which link to the native chicken's libchicken. Where it is found
  # by soname, they get the cross chicken's, which is already loaded, but on
  # Darwin they refer to the native one by path, and a second runtime in the
  # process makes the compiler panic. Searching DYLD_LIBRARY_PATH by leaf name
  # comes first, so it makes them share the cross chicken's. Each program sets
  # it anew, as the shell that csc runs the compiler through clears it.
  ${if isCrossChicken && stdenv.hostPlatform.isDarwin then "postFixup" else null} = ''
    for program in $out/bin/*; do
      wrapProgram "$program" --prefix DYLD_LIBRARY_PATH : "$lib/lib"
    done
  '';

  __structuredAttrs = true;
  enableParallelBuilding = true;
  # On platforms that need relinking, the install-bin target deletes
  # libchicken.so and relinks it, racing with install-libs, which installs it.
  enableParallelInstalling = false;

  # Neither release's test suite survives the Darwin sandbox, for a different
  # reason each: CHICKEN 5's runtests.sh drives the compiler through
  # /usr/bin/env, which the sandbox denies, and CHICKEN 6's csc tests run
  # binaries whose install name install_name_tool has already rewritten to
  # $out/lib/libchicken.dylib, which does not exist until the install phase.
  # A cross chicken's test suite builds programs for the target, which cannot
  # run here. A static chicken's test suite builds shared libraries, which it
  # cannot.
  doCheck = !stdenv.hostPlatform.isDarwin && !isCrossChicken && !stdenv.hostPlatform.isStatic;

  # The generic check phase probes for a target with a bare `make check`, which
  # fails here because PLATFORM is only given in makeFlags, so the test suite
  # would be silently skipped.
  checkTarget = "check";

  postCheck = ''
    ./csi -R chicken.pathname -R chicken.platform \
       -p "(assert (equal? \"${toString finalAttrs.binaryVersion}\" (pathname-file (car (repository-path)))))"
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "csi -version";
  };

  meta = {
    homepage = "https://call-cc.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      corngood
      nagy
      konst-aa
      Xophmeister
    ];
    platforms = lib.platforms.unix;
    description = "Portable compiler for the Scheme programming language";
    longDescription = ''
      CHICKEN is a compiler for the Scheme programming language.
      CHICKEN produces portable and efficient C, supports almost all
      of the ${standard} Scheme language standard, and includes many
      enhancements and extensions. CHICKEN runs on Linux, macOS,
      Windows, and many Unix flavours.
    '';
  };
})
