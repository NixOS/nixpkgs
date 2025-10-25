{
  lib,
  stdenv,
  buildPackages,
  buildHaskellPackages,
  ghc,
  jailbreak-cabal,
  hscolour,
  cpphs,
  runCommandCC,
  ghcWithHoogle,
  ghcWithPackages,
  haskellLib,
  iserv-proxy,
  nodejs,
  writeShellScriptBin,
}:

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;

  crossSupport = rec {
    emulator = stdenv.hostPlatform.emulator buildPackages;

    hasBuiltinTH = stdenv.hostPlatform.isGhcjs;

    canProxyTH =
      lib.versionAtLeast ghc.version "9.6" && stdenv.hostPlatform.emulatorAvailable buildPackages;

    # Many suites use Template Haskell for test discovery, including QuickCheck
    canCheck = hasBuiltinTH || canProxyTH;

    # stdenv.make-derivation sets `doCheck = false` when the build platform can't directly execute the host platform
    # which means the `checkPhase` ends up disabled for cross and we need to sneak it back in somehow
    # TODO: avoid this workaround - add some sort of doCheckEmulated?
    checkPhaseSidecar = doCheck: drv: anchor: lib.trim ''
      ${anchor}
      ${lib.optionalString (doCheck && isCross) drv.checkPhase}
    '';

    iservWrapper =
      let
        buildProxy = lib.getExe' iserv-proxy.build "iserv-proxy";

        wrapperScript =
          enableProfiling:
          let
            overrides = haskellLib.overrideCabal {
              enableLibraryProfiling = enableProfiling;
              enableExecutableProfiling = enableProfiling;
            };
            hostProxy = lib.getExe' (overrides iserv-proxy.host) "iserv-proxy-interpreter";
          in
          buildPackages.writeShellScriptBin ("iserv-wrapper" + lib.optionalString enableProfiling "-prof") ''
            set -euo pipefail
            PORT=$((5000 + $RANDOM % 5000))
            (>&2 echo "---> Starting interpreter on port $PORT")
            ${emulator} ${hostProxy} tmp $PORT &
            RISERV_PID="$!"
            trap "kill $RISERV_PID" EXIT # Needs cleanup when building without sandbox
            ${buildProxy} $@ 127.0.0.1 "$PORT"
            (>&2 echo "---> killing interpreter...")
          '';

        # GHC will add `-prof` to the external interpreter when doing a profiled build.
        # Since a single derivation can build with both profiling and non-profiling versions
        # we need both versions made available
        both = buildPackages.symlinkJoin {
          name = "iserv-wrapper-both";
          paths = builtins.map wrapperScript [
            false
            true
          ];
        };

      in
      "${both}/bin/iserv-wrapper";
  };

  # Pass the "wrong" C compiler rather than none at all so packages that just
  # use the C preproccessor still work, see
  # https://github.com/haskell/cabal/issues/6466 for details.
  cc =
    if stdenv.hasCC then
      "$CC"
    else if stdenv.hostPlatform.isGhcjs then
      "${emscripten}/bin/emcc"
    else
      "$CC_FOR_BUILD";

  inherit (buildPackages)
    fetchurl
    removeReferencesTo
    pkg-config
    coreutils
    glibcLocales
    emscripten
    ;

in

{
  pname,
  dontStrip ? stdenv.hostPlatform.isGhcjs,
  version,
  revision ? null,
  sha256 ? null,
  src ? fetchurl {
    url = "mirror://hackage/${pname}-${version}.tar.gz";
    inherit sha256;
  },
  sourceRoot ? null,
  setSourceRoot ? null,
  # Extra environment variables to set during the build.
  # See: `../../../doc/languages-frameworks/haskell.section.md`
  env ? { },
  buildDepends ? [ ],
  setupHaskellDepends ? [ ],
  libraryHaskellDepends ? [ ],
  executableHaskellDepends ? [ ],
  buildTarget ? "",
  buildTools ? [ ],
  libraryToolDepends ? [ ],
  executableToolDepends ? [ ],
  testToolDepends ? [ ],
  benchmarkToolDepends ? [ ],
  configureFlags ? [ ],
  buildFlags ? [ ],
  haddockFlags ? [ ],
  description ? null,
  doCheck ? isCross -> crossSupport.canCheck,
  doBenchmark ? false,
  doHoogle ? true,
  doHaddockQuickjump ? doHoogle,
  doInstallIntermediates ? false,
  editedCabalFile ? null,
  enableLibraryProfiling ? !stdenv.hostPlatform.isGhcjs,
  enableExecutableProfiling ? false,
  profilingDetail ? "exported-functions",
  # TODO enable shared libs for cross-compiling
  enableSharedExecutables ? false,
  enableSharedLibraries ?
    !stdenv.hostPlatform.isStatic
    && (ghc.enableShared or false)
    && !stdenv.hostPlatform.useAndroidPrebuilt, # TODO: figure out why /build leaks into RPATH
  enableDeadCodeElimination ? (!stdenv.hostPlatform.isDarwin), # TODO: use -dead_strip for darwin
  # Disabling this for JS prevents this crash: https://gitlab.haskell.org/ghc/ghc/-/issues/23235
  enableStaticLibraries ?
    !(stdenv.hostPlatform.isWindows || stdenv.hostPlatform.isWasm || stdenv.hostPlatform.isGhcjs),
  enableHsc2hsViaAsm ? stdenv.hostPlatform.isWindows,
  extraLibraries ? [ ],
  librarySystemDepends ? [ ],
  executableSystemDepends ? [ ],
  # On macOS, statically linking against system frameworks is not supported;
  # see https://developer.apple.com/library/content/qa/qa1118/_index.html
  # They must be propagated to the environment of any executable linking with the library
  libraryFrameworkDepends ? [ ],
  executableFrameworkDepends ? [ ],
  homepage ? "https://hackage.haskell.org/package/${pname}",
  platforms ? lib.platforms.all, # GHC can cross-compile
  badPlatforms ? lib.platforms.none,
  hydraPlatforms ? null,
  hyperlinkSource ? true,
  isExecutable ? false,
  isLibrary ? !isExecutable,
  jailbreak ? false,
  license ? null,
  enableParallelBuilding ? true,
  maintainers ? null,
  teams ? null,
  changelog ? null,
  mainProgram ? null,
  doCoverage ? false,
  doHaddock ? !(ghc.isHaLVM or false) && (ghc.hasHaddock or true),
  doHaddockInterfaces ? doHaddock && lib.versionAtLeast ghc.version "9.0.1",
  passthru ? { },
  pkg-configDepends ? [ ],
  libraryPkgconfigDepends ? [ ],
  executablePkgconfigDepends ? [ ],
  testPkgconfigDepends ? [ ],
  benchmarkPkgconfigDepends ? [ ],
  testDepends ? [ ],
  testHaskellDepends ? [ ],
  testSystemDepends ? [ ],
  testFrameworkDepends ? [ ],
  benchmarkDepends ? [ ],
  benchmarkHaskellDepends ? [ ],
  benchmarkSystemDepends ? [ ],
  benchmarkFrameworkDepends ? [ ],
  # testTarget is deprecated. Use testTargets instead.
  testTarget ? "",
  testTargets ? lib.strings.splitString " " testTarget,
  testFlags ? [ ],
  broken ? false,
  preCompileBuildDriver ? null,
  postCompileBuildDriver ? null,
  preUnpack ? null,
  postUnpack ? null,
  patches ? null,
  patchPhase ? null,
  prePatch ? "",
  postPatch ? "",
  preConfigure ? null,
  postConfigure ? null,
  preBuild ? null,
  postBuild ? null,
  preHaddock ? null,
  postHaddock ? null,
  installPhase ? null,
  preInstall ? null,
  postInstall ? null,
  checkPhase ? null,
  preCheck ? null,
  postCheck ? null,
  preFixup ? null,
  postFixup ? null,
  shellHook ? "",
  coreSetup ? false, # Use only core packages to build Setup.hs.
  useCpphs ? false,
  hardeningDisable ? null,
  enableSeparateBinOutput ? false,
  enableSeparateDataOutput ? false,
  enableSeparateDocOutput ? doHaddock,
  enableSeparateIntermediatesOutput ? false,
  # Don't fail at configure time if there are multiple versions of the
  # same package in the (recursive) dependencies of the package being
  # built. Will delay failures, if any, to compile time.
  allowInconsistentDependencies ? false,
  maxBuildCores ? 16, # more cores usually don't improve performance: https://ghc.haskell.org/trac/ghc/ticket/9221
  # If set to true, this builds a pre-linked .o file for this Haskell library.
  # This can make it slightly faster to load this library into GHCi, but takes
  # extra disk space and compile time.
  enableLibraryForGhci ? false,
  # Set this to a previous build of this same package to reuse the intermediate
  # build products from that prior build as a starting point for accelerating
  # this build
  previousIntermediates ? null,
  # References to these store paths are forbidden in the produced output.
  disallowedRequisites ? [ ],
  # Whether to allow the produced output to refer to `ghc`.
  #
  # This is used by `haskell.lib.justStaticExecutables` to help prevent static
  # Haskell binaries from having erroneous dependencies on GHC.
  #
  # See https://nixos.org/manual/nixpkgs/unstable/#haskell-packaging-helpers
  # or its source doc/languages-frameworks/haskell.section.md
  disallowGhcReference ? false,
  # By default we convert the `.cabal` file to Unix line endings to work around
  # Hackage converting them to DOS line endings when revised, see
  # <https://github.com/haskell/hackage-server/issues/316>.
  # Pass `true` to disable this behavior.
  dontConvertCabalFileToUnix ? false,
  # Cabal 3.8 which is shipped by default for GHC >= 9.3 always calls
  # `pkg-config --libs --static` as part of the configure step. This requires
  # Requires.private dependencies of pkg-config dependencies to be present in
  # PKG_CONFIG_PATH which is normally not the case in nixpkgs (except in pkgsStatic).
  # Since there is no patch or upstream patch yet, we replicate the automatic
  # propagation of dependencies in pkgsStatic for allPkgConfigDepends for
  # GHC >= 9.3 by default. This option allows overriding this behavior manually
  # if mismatching Cabal and GHC versions are used.
  # See also <https://github.com/haskell/cabal/issues/8455>.
  __propagatePkgConfigDepends ? lib.versionAtLeast ghc.version "9.3",
  # Propagation can easily lead to the argv limit being exceeded in linker or C
  # compiler invocations. To work around this we can only propagate derivations
  # that are known to provide pkg-config modules, as indicated by the presence
  # of `meta.pkgConfigModules`. This option defaults to false for now, since
  # this metadata is far from complete in nixpkgs.
  __onlyPropagateKnownPkgConfigModules ? false,

  enableExternalInterpreter ? isCross && crossSupport.canProxyTH,
}@args:

assert editedCabalFile != null -> revision != null;

# We only use iserv-proxy for the external interpreter
assert enableExternalInterpreter -> crossSupport.canProxyTH;

# --enable-static does not work on windows. This is a bug in GHC.
# --enable-static will pass -staticlib to ghc, which only works for mach-o and elf.
assert stdenv.hostPlatform.isWindows -> enableStaticLibraries == false;
assert stdenv.hostPlatform.isWasm -> enableStaticLibraries == false;

let

  inherit (lib)
    optional
    optionals
    optionalString
    versionAtLeast
    concatStringsSep
    enableFeature
    optionalAttrs
    ;

  isHaLVM = ghc.isHaLVM or false;

  # GHC used for building Setup.hs
  #
  # Same as our GHC, unless we're cross, in which case it is native GHC with the
  # same version.
  nativeGhc = buildHaskellPackages.ghc;

  # the target dir for haddock documentation
  docdir = docoutput: docoutput + "/share/doc/" + pname + "-" + version;

  binDir = if enableSeparateBinOutput then "$bin/bin" else "$out/bin";

  newCabalFileUrl = "mirror://hackage/${pname}-${version}/revision/${revision}.cabal";
  newCabalFile = fetchurl {
    url = newCabalFileUrl;
    sha256 = editedCabalFile;
    name = "${pname}-${version}-r${revision}.cabal";
  };

  defaultSetupHs = builtins.toFile "Setup.hs" ''
    import Distribution.Simple
    main = defaultMain
  '';

  # This awk expression transforms a package conf file like
  #
  #   author:               John Doe <john-doe@example.com>
  #   description:
  #       The purpose of this library is to do
  #       foo and bar among other things
  #
  # into a more easily processeable form:
  #
  #   author: John Doe <john-doe@example.com>
  #   description: The purpose of this library is to do foo and bar among other things
  unprettyConf = builtins.toFile "unpretty-cabal-conf.awk" ''
    /^[^ ]+:/ {
      # When the line starts with a new field, terminate the previous one with a newline
      if (started == 1) print ""
      # to strip leading spaces
      $1=$1
      printf "%s", $0
      started=1
    }

    /^ +/ {
      # to strip leading spaces
      $1=$1
      printf " %s", $0
    }

    # Terminate the final field with a newline
    END { print "" }
  '';

  crossCabalFlags = [
    "--with-ghc=${ghcCommand}"
    "--with-ghc-pkg=${ghc.targetPrefix}ghc-pkg"
    "--with-gcc=${cc}"
  ]
  ++ optionals stdenv.hasCC [
    "--with-ld=${stdenv.cc.bintools.targetPrefix}ld"
    "--with-ar=${stdenv.cc.bintools.targetPrefix}ar"
    # use the one that comes with the cross compiler.
    "--with-hsc2hs=${ghc.targetPrefix}hsc2hs"
    "--with-strip=${stdenv.cc.bintools.targetPrefix}strip"
  ]
  ++ optionals (!isHaLVM) [
    "--hsc2hs-option=--cross-compile"
    (optionalString enableHsc2hsViaAsm "--hsc2hs-option=--via-asm")
  ]
  ++ optional (allPkgconfigDepends != [ ]) "--with-pkg-config=${pkg-config.targetPrefix}pkg-config"

  ++ optionals enableExternalInterpreter (
    map (opt: "--ghc-option=${opt}") [
      "-fexternal-interpreter"
      "-pgmi"
      crossSupport.iservWrapper
    ]
  );

  makeGhcOptions = opts: lib.concatStringsSep " " (map (opt: "--ghc-option=${opt}") opts);

  buildFlagsString = optionalString (buildFlags != [ ]) (" " + concatStringsSep " " buildFlags);

  defaultConfigureFlags = [
    "--verbose"
    "--prefix=$out"
    # Note: This must be kept in sync manually with mkGhcLibdir
    ("--libdir=\\$prefix/lib/\\$compiler" + lib.optionalString (ghc ? hadrian) "/lib")
    "--libsubdir=\\$abi/\\$libname"
    (optionalString enableSeparateDataOutput "--datadir=$data/share/${ghcNameWithPrefix}")
    (optionalString enableSeparateDocOutput "--docdir=${docdir "$doc"}")
  ]
  ++ optionals stdenv.hasCC [
    "--with-gcc=$CC" # Clang won't work without that extra information.
  ]
  ++ [
    "--package-db=$packageConfDir"
    (optionalString (
      enableSharedExecutables && stdenv.hostPlatform.isLinux
    ) "--ghc-option=-optl=-Wl,-rpath=$out/${ghcLibdir}/${pname}-${version}")
    (optionalString (
      enableSharedExecutables && stdenv.hostPlatform.isDarwin
    ) "--ghc-option=-optl=-Wl,-headerpad_max_install_names")
    (optionalString enableParallelBuilding (makeGhcOptions [
      "-j$NIX_BUILD_CORES"
      "+RTS"
      "-A64M"
      "-RTS"
    ]))
    (optionalString useCpphs (
      "--with-cpphs=${cpphs}/bin/cpphs "
      + (makeGhcOptions [
        "-cpp"
        "-pgmP${cpphs}/bin/cpphs"
        "-optP--cpp"
      ])
    ))
    (enableFeature enableLibraryProfiling "library-profiling")
    (optionalString (
      enableExecutableProfiling || enableLibraryProfiling
    ) "--profiling-detail=${profilingDetail}")
    (enableFeature enableExecutableProfiling "profiling")
    (enableFeature enableSharedLibraries "shared")
    (enableFeature doCoverage "coverage")
    (enableFeature enableStaticLibraries "static")
    (enableFeature enableSharedExecutables "executable-dynamic")
    (enableFeature doCheck "tests")
    (enableFeature doBenchmark "benchmarks")
    "--enable-library-vanilla" # TODO: Should this be configurable?
    (enableFeature enableLibraryForGhci "library-for-ghci")
    (enableFeature enableDeadCodeElimination "split-sections")
    (enableFeature (!dontStrip) "library-stripping")
    (enableFeature (!dontStrip) "executable-stripping")
  ]
  ++ optionals isCross (
    [
      "--configure-option=--host=${stdenv.hostPlatform.config}"
    ]
    ++ crossCabalFlags
  )
  ++ optionals enableSeparateBinOutput [
    "--bindir=${binDir}"
  ]
  ++ optionals (doHaddockInterfaces && isLibrary) [
    "--ghc-option=-haddock"
  ];

  postPhases = optional doInstallIntermediates "installIntermediatesPhase";

  setupCompileFlags = [
    (optionalString (!coreSetup) "-package-db=$setupPackageConfDir")
    "-threaded" # https://github.com/haskell/cabal/issues/2398
  ];

  isHaskellPkg = x: x ? isHaskellLibrary;

  # Work around a Cabal bug requiring pkg-config --static --libs to work even
  # when linking dynamically, affecting Cabal 3.8 and 3.9.
  # https://github.com/haskell/cabal/issues/8455
  #
  # For this, we treat the runtime system/pkg-config dependencies of a Haskell
  # derivation as if they were propagated from their dependencies which allows
  # pkg-config --static to work in most cases.
  allPkgconfigDepends =
    let
      # If __onlyPropagateKnownPkgConfigModules is set, packages without
      # meta.pkgConfigModules will be filtered out, otherwise all packages in
      # buildInputs and propagatePlainBuildInputs are propagated.
      propagateValue =
        drv: lib.isDerivation drv && (__onlyPropagateKnownPkgConfigModules -> drv ? meta.pkgConfigModules);

      # Take list of derivations and return list of the transitive dependency
      # closure, only taking into account buildInputs. Loosely based on
      # closePropagationFast.
      propagatePlainBuildInputs =
        drvs:
        map (i: i.val) (
          builtins.genericClosure {
            startSet = map (drv: {
              key = drv.outPath;
              val = drv;
            }) (builtins.filter propagateValue drvs);
            operator =
              { val, ... }:
              builtins.concatMap (
                drv:
                if propagateValue drv then
                  [
                    {
                      key = drv.outPath;
                      val = drv;
                    }
                  ]
                else
                  [ ]
              ) (val.buildInputs or [ ] ++ val.propagatedBuildInputs or [ ]);
          }
        );
    in

    if __propagatePkgConfigDepends then
      propagatePlainBuildInputs allPkgconfigDepends'
    else
      allPkgconfigDepends';
  allPkgconfigDepends' =
    pkg-configDepends
    ++ libraryPkgconfigDepends
    ++ executablePkgconfigDepends
    ++ optionals doCheck testPkgconfigDepends
    ++ optionals doBenchmark benchmarkPkgconfigDepends;

  depsBuildBuild = [
    nativeGhc
  ]
  # CC_FOR_BUILD may be necessary if we have no C preprocessor for the host
  # platform. See crossCabalFlags above for more details.
  ++ lib.optionals (!stdenv.hasCC) [ buildPackages.stdenv.cc ];
  collectedToolDepends =
    buildTools
    ++ libraryToolDepends
    ++ executableToolDepends
    ++ optionals doCheck testToolDepends
    ++ optionals doBenchmark benchmarkToolDepends;
  nativeBuildInputs = [
    ghc
    removeReferencesTo
  ]
  ++ optional (allPkgconfigDepends != [ ]) (
    assert pkg-config != null;
    pkg-config
  )
  ++ setupHaskellDepends
  ++ collectedToolDepends
  ++ optional stdenv.hostPlatform.isGhcjs nodejs;
  propagatedBuildInputs =
    buildDepends ++ libraryHaskellDepends ++ executableHaskellDepends ++ libraryFrameworkDepends;
  otherBuildInputsHaskell =
    optionals doCheck (testDepends ++ testHaskellDepends)
    ++ optionals doBenchmark (benchmarkDepends ++ benchmarkHaskellDepends);
  otherBuildInputsSystem =
    extraLibraries
    ++ librarySystemDepends
    ++ executableSystemDepends
    ++ executableFrameworkDepends
    ++ allPkgconfigDepends
    ++ optionals doCheck (testSystemDepends ++ testFrameworkDepends)
    ++ optionals doBenchmark (benchmarkSystemDepends ++ benchmarkFrameworkDepends);
  # TODO next rebuild just define as `otherBuildInputsHaskell ++ otherBuildInputsSystem`
  otherBuildInputs =
    extraLibraries
    ++ librarySystemDepends
    ++ executableSystemDepends
    ++ executableFrameworkDepends
    ++ allPkgconfigDepends
    ++ optionals doCheck (
      testDepends ++ testHaskellDepends ++ testSystemDepends ++ testFrameworkDepends
    )
    ++ optionals doBenchmark (
      benchmarkDepends ++ benchmarkHaskellDepends ++ benchmarkSystemDepends ++ benchmarkFrameworkDepends
    );

  setupCommand = "./Setup";

  ghcCommand' = "ghc";
  ghcCommand = "${ghc.targetPrefix}${ghcCommand'}";

  ghcNameWithPrefix = "${ghc.targetPrefix}${ghc.haskellCompilerName}";
  mkGhcLibdir =
    ghc:
    "lib/${ghc.targetPrefix}${ghc.haskellCompilerName}" + lib.optionalString (ghc ? hadrian) "/lib";
  ghcLibdir = mkGhcLibdir ghc;

  nativeGhcCommand = "${nativeGhc.targetPrefix}ghc";

  buildPkgDb = thisGhc: packageConfDir: ''
    # If this dependency has a package database, then copy the contents of it,
    # unless it is one of our GHCs. These can appear in our dependencies when
    # we are doing native builds, and they have package databases in them, but
    # we do not want to copy them over.
    #
    # We don't need to, since those packages will be provided by the GHC when
    # we compile with it, and doing so can result in having multiple copies of
    # e.g. Cabal in the database with the same name and version, which is
    # ambiguous.
    if [ -d "$p/${mkGhcLibdir thisGhc}/package.conf.d" ] && [ "$p" != "${ghc}" ] && [ "$p" != "${nativeGhc}" ]; then
      cp -f "$p/${mkGhcLibdir thisGhc}/package.conf.d/"*.conf ${packageConfDir}/
      continue
    fi
  '';

  intermediatesDir = "share/haskell/${ghc.version}/${pname}-${version}/dist";

  jsexe = rec {
    shouldAdd = stdenv.hostPlatform.isGhcjs && isExecutable;
    shouldCopy = shouldAdd && !doInstallIntermediates;
    shouldSymlink = shouldAdd && doInstallIntermediates;
  };

  # This is a script suitable for --test-wrapper of Setup.hs' test command
  # (https://cabal.readthedocs.io/en/3.12/setup-commands.html#cmdoption-runhaskell-Setup.hs-test-test-wrapper).
  # We use it to set some environment variables that the test suite may need,
  # e.g. GHC_PACKAGE_PATH to invoke GHC(i) at runtime with build dependencies
  # available. See the comment accompanying checkPhase below on how to customize
  # this behavior. We need to use a wrapper script since Cabal forbids setting
  # certain environment variables since they can alter GHC's behavior (e.g.
  # GHC_PACKAGE_PATH) and cause failures. While building, Cabal will set
  # GHC_ENVIRONMENT to make the packages picked at configure time available to
  # GHC, but unfortunately not at test time. The test wrapper script will be
  # executed after such environment checks, so we can take some liberties which
  # is unproblematic since we know our synthetic package db matches what Cabal
  # will see at configure time exactly. See also
  # <https://github.com/haskell/cabal/issues/7792>.
  testWrapperScript = buildPackages.writeShellScript "haskell-generic-builder-test-wrapper.sh" ''
    set -eu

    # We expect this to be either empty or set by checkPhase
    if [[ -n "''${NIX_GHC_PACKAGE_PATH_FOR_TEST}" ]]; then
      export GHC_PACKAGE_PATH="''${NIX_GHC_PACKAGE_PATH_FOR_TEST}"
    fi

    exec ${if (isCross && crossSupport.canCheck) then "node" else crossSupport.emulator} "$@"
  '';

  testTargetsString =
    lib.warnIf (testTarget != "")
      "haskellPackages.mkDerivation: testTarget is deprecated. Use testTargets instead"
      (lib.concatStringsSep " " testTargets);

  env' = {
    LANG = "en_US.UTF-8"; # GHC needs the locale configured during the Haddock phase.
  }
  // env
  # Implicit pointer to integer conversions are errors by default since clang 15.
  # Works around https://gitlab.haskell.org/ghc/ghc/-/issues/23456. krank:ignore-line
  # A fix was included in GHC 9.10.* and backported to 9.6.5 and 9.8.2 (but we no longer
  # ship 9.8.1).
  // optionalAttrs (lib.versionOlder ghc.version "9.6.5" && stdenv.hasCC && stdenv.cc.isClang) {
    NIX_CFLAGS_COMPILE =
      "-Wno-error=int-conversion"
      + lib.optionalString (env ? NIX_CFLAGS_COMPILE) (" " + env.NIX_CFLAGS_COMPILE);
  };

in
lib.fix (
  drv:

  stdenv.mkDerivation (
    {
      inherit pname version;

      outputs = [
        "out"
      ]
      ++ (optional enableSeparateDataOutput "data")
      ++ (optional enableSeparateDocOutput "doc")
      ++ (optional enableSeparateBinOutput "bin")
      ++ (optional enableSeparateIntermediatesOutput "intermediates");

      setOutputFlags = false;

      pos = builtins.unsafeGetAttrPos "pname" args;

      prePhases = [ "setupCompilerEnvironmentPhase" ];
      preConfigurePhases = [ "compileBuildDriverPhase" ];
      preInstallPhases = [ "haddockPhase" ];

      inherit src;

      inherit depsBuildBuild nativeBuildInputs;
      buildInputs =
        otherBuildInputs
        ++ optionals (!isLibrary) propagatedBuildInputs
        # For patchShebangsAuto in fixupPhase
        ++ optionals stdenv.hostPlatform.isGhcjs [ nodejs ];
      propagatedBuildInputs = optionals isLibrary propagatedBuildInputs;

      env =
        optionalAttrs (stdenv.buildPlatform.libc == "glibc") {
          LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive";
        }
        // env';

      prePatch =
        optionalString (editedCabalFile != null) ''
          echo "Replace Cabal file with edited version from ${newCabalFileUrl}."
          cp ${newCabalFile} ${pname}.cabal
        ''
        + prePatch
        + "\n"
        # cabal2nix-generated expressions run hpack not until prePatch to create
        # the .cabal file (if necessary)
        + lib.optionalString (!dontConvertCabalFileToUnix) ''
          sed -i -e 's/\r$//' *.cabal
        '';

      postPatch =
        optionalString jailbreak ''
          echo "Run jailbreak-cabal to lift version restrictions on build inputs."
          ${jailbreak-cabal}/bin/jailbreak-cabal *.cabal
        ''
        + postPatch;

      setupCompilerEnvironmentPhase = ''
        NIX_BUILD_CORES=$(( NIX_BUILD_CORES < ${toString maxBuildCores} ? NIX_BUILD_CORES : ${toString maxBuildCores} ))
        runHook preSetupCompilerEnvironment

        echo "Build with ${ghc}."
        ${optionalString (isLibrary && hyperlinkSource) "export PATH=${hscolour}/bin:$PATH"}

        builddir="$(mktemp -d)"
        setupPackageConfDir="$builddir/setup-package.conf.d"
        mkdir -p $setupPackageConfDir
        packageConfDir="$builddir/package.conf.d"
        mkdir -p $packageConfDir

        setupCompileFlags="${concatStringsSep " " setupCompileFlags}"
        configureFlags="${concatStringsSep " " defaultConfigureFlags} $configureFlags"
      ''
      # We build the Setup.hs on the *build* machine, and as such should only add
      # dependencies for the build machine.
      #
      # pkgs* arrays defined in stdenv/setup.hs
      + ''
        for p in "''${pkgsBuildBuild[@]}" "''${pkgsBuildHost[@]}" "''${pkgsBuildTarget[@]}"; do
          ${buildPkgDb nativeGhc "$setupPackageConfDir"}
        done
        ${nativeGhcCommand}-pkg --package-db="$setupPackageConfDir" recache
      ''
      # For normal components
      + ''
        for p in "''${pkgsHostHost[@]}" "''${pkgsHostTarget[@]}"; do
          ${buildPkgDb ghc "$packageConfDir"}
          if [ -d "$p/include" ]; then
            appendToVar configureFlags "--extra-include-dirs=$p/include"
          fi
          if [ -d "$p/lib" ]; then
            appendToVar configureFlags "--extra-lib-dirs=$p/lib"
          fi
          if [[ -d "$p/Library/Frameworks" ]]; then
            appendToVar configureFlags "--extra-framework-dirs=$p/Library/Frameworks"
          fi
      ''
      + ''
        done
      ''
      + (optionalString stdenv.hostPlatform.isGhcjs ''
        export EM_CACHE="$(realpath "$(mktemp -d emcache.XXXXXXXXXX)")"
        cp -Lr ${emscripten}/share/emscripten/cache/* "$EM_CACHE/"
        chmod u+rwX -R "$EM_CACHE"
      '')
      # only use the links hack if we're actually building dylibs. otherwise, the
      # "dynamic-library-dirs" point to nonexistent paths, and the ln command becomes
      # "ln -s $out/lib/links", which tries to recreate the links dir and fails
      #
      # Note: We need to disable this work-around when using intermediate build
      # products from a prior build because otherwise Nix will change permissions on
      # the `$out/lib/links` directory to read-only when the build is done after the
      # dist directory has already been exported, which triggers an unnecessary
      # rebuild of modules included in the exported dist directory.
      + (optionalString
        (
          stdenv.hostPlatform.isDarwin
          && (enableSharedLibraries || enableSharedExecutables)
          && !enableSeparateIntermediatesOutput
        )
        ''
          # Work around a limit in the macOS Sierra linker on the number of paths
          # referenced by any one dynamic library:
          #
          # Create a local directory with symlinks of the *.dylib (macOS shared
          # libraries) from all the dependencies.
          local dynamicLinksDir="$out/lib/links"
          mkdir -p $dynamicLinksDir

          # Unprettify all package conf files before reading/writing them
          for d in "$packageConfDir/"*; do
            # gawk -i inplace seems to strip the last newline
            gawk -f ${unprettyConf} "$d" > tmp
            mv tmp "$d"
          done

          for d in $(grep '^dynamic-library-dirs:' "$packageConfDir"/* | cut -d' ' -f2- | tr ' ' '\n' | sort -u); do
            for lib in "$d/"*.{dylib,so}; do
              # Allow overwriting because C libs can be pulled in multiple times.
              ln -sf "$lib" "$dynamicLinksDir"
            done
          done
          # Edit the local package DB to reference the links directory.
          for f in "$packageConfDir/"*.conf; do
            sed -i "s,dynamic-library-dirs: .*,dynamic-library-dirs: $dynamicLinksDir," "$f"
          done
        ''
      )
      + ''
        ${ghcCommand}-pkg --package-db="$packageConfDir" recache

        runHook postSetupCompilerEnvironment
      '';

      compileBuildDriverPhase = ''
        runHook preCompileBuildDriver

        for i in Setup.hs Setup.lhs ${defaultSetupHs}; do
          test -f $i && break
        done

        echo setupCompileFlags: $setupCompileFlags
        ${nativeGhcCommand} $setupCompileFlags --make -o Setup -odir $builddir -hidir $builddir $i

        runHook postCompileBuildDriver
      '';

      # Cabal takes flags like `--configure-option=--host=...` instead
      configurePlatforms = [ ];
      inherit configureFlags;

      # Note: the options here must be always added, regardless of whether the
      # package specifies `hardeningDisable`.
      hardeningDisable =
        lib.optionals (args ? hardeningDisable) hardeningDisable
        ++ lib.optional (ghc.isHaLVM or false) "all";

      configurePhase = ''
        runHook preConfigure

        echo configureFlags: $configureFlags
        ${setupCommand} configure $configureFlags 2>&1 | ${coreutils}/bin/tee "$NIX_BUILD_TOP/cabal-configure.log"
        ${lib.optionalString (!allowInconsistentDependencies) ''
          if grep -E -q -z 'Warning:.*depends on multiple versions' "$NIX_BUILD_TOP/cabal-configure.log"; then
            echo >&2 "*** abort because of serious configure-time warning from Cabal"
            exit 1
          fi
        ''}

        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild
      ''
      + lib.optionalString (previousIntermediates != null) ''
        mkdir -p dist;
        rm -r dist/build
        cp -r ${previousIntermediates}/${intermediatesDir}/build dist/build
        find dist/build -exec chmod u+w {} +
        find dist/build -exec touch -d '1970-01-01T00:00:00Z' {} +
      ''
      + ''
        ${setupCommand} build ${buildTarget}${buildFlagsString}
        ${crossSupport.checkPhaseSidecar doCheck drv "runHook postBuild"}
      '';

      inherit doCheck;

      # Run test suite(s) and pass `checkFlags` as well as `checkFlagsArray`.
      # `testFlags` are added to `checkFlagsArray` each prefixed with
      # `--test-option`, so Cabal passes it to the underlying test suite binary.
      #
      # We also take care of setting GHC_PACKAGE_PATH during test suite execution,
      # so it can run GHC(i) with build dependencies available:
      # - If NIX_GHC_PACKAGE_PATH_FOR_TEST is set, it become the value of GHC_PACKAGE_PATH
      #   while the test suite is executed.
      # - If it is empty, it'll be unset during test suite execution.
      # - Otherwise GHC_PACKAGE_PATH will have the package db used for configuring
      #   plus GHC's core packages.
      checkPhase = ''
        runHook preCheck
        checkFlagsArray+=(
          "--show-details=streaming"
          "--test-wrapper=${testWrapperScript}"
          ${lib.escapeShellArgs (map (opt: "--test-option=${opt}") testFlags)}
        )
        export NIX_GHC_PACKAGE_PATH_FOR_TEST="''${NIX_GHC_PACKAGE_PATH_FOR_TEST:-$packageConfDir:}"
        ${setupCommand} test ${testTargetsString} $checkFlags ''${checkFlagsArray:+"''${checkFlagsArray[@]}"}
        runHook postCheck
      '';

      haddockPhase = ''
        runHook preHaddock
        ${optionalString (doHaddock && isLibrary) ''
          ${setupCommand} haddock --html \
            ${optionalString doHoogle "--hoogle"} \
            ${optionalString doHaddockQuickjump "--quickjump"} \
            ${optionalString (isLibrary && hyperlinkSource) "--hyperlink-source"} \
            ${lib.concatStringsSep " " haddockFlags}
        ''}
        runHook postHaddock
      '';

      installPhase = ''
        runHook preInstall

        ${
          if !isLibrary && buildTarget == "" then
            "${setupCommand} install"
          # ^^ if the project is not a library, and no build target is specified, we can just use "install".
          else if !isLibrary then
            "${setupCommand} copy ${buildTarget}"
          # ^^ if the project is not a library, and we have a build target, then use "copy" to install
          # just the target specified; "install" will error here, since not all targets have been built.
          else
            ''
              ${setupCommand} copy ${buildTarget}
              local packageConfDir="$out/${ghcLibdir}/package.conf.d"
              local packageConfFile="$packageConfDir/${pname}-${version}.conf"
              mkdir -p "$packageConfDir"
              ${setupCommand} register --gen-pkg-config=$packageConfFile
              if [ -d "$packageConfFile" ]; then
                mv "$packageConfFile/"* "$packageConfDir"
                rmdir "$packageConfFile"
              fi
              for packageConfFile in "$packageConfDir/"*; do
                local pkgId=$(gawk -f ${unprettyConf} "$packageConfFile" \
                  | grep '^id:' | cut -d' ' -f2)
                mv "$packageConfFile" "$packageConfDir/$pkgId.conf"
              done

              # delete confdir if there are no libraries
              find $packageConfDir -maxdepth 0 -empty -delete;
            ''
        }


        ${optionalString doCoverage "mkdir -p $out/share && cp -r dist/hpc $out/share"}

        ${optionalString jsexe.shouldCopy ''
          for jsexeDir in dist/build/*/*.jsexe; do
            bn=$(basename $jsexeDir)
            exe="''${bn%.jsexe}"
            cp -r dist/build/$exe/$exe.jsexe ${binDir}
          done
        ''}

        ${optionalString enableSeparateDocOutput ''
          for x in ${docdir "$doc"}"/html/src/"*.html; do
            remove-references-to -t $out $x
          done
          mkdir -p $doc
        ''}
        ${optionalString enableSeparateDataOutput "mkdir -p $data"}

        runHook postInstall
      '';

      ${if doInstallIntermediates then "installIntermediatesPhase" else null} = ''
        runHook preInstallIntermediates
        intermediatesOutput=${if enableSeparateIntermediatesOutput then "$intermediates" else "$out"}
        installIntermediatesDir="$intermediatesOutput/${intermediatesDir}"
        mkdir -p "$installIntermediatesDir"
        cp -r dist/build "$installIntermediatesDir"
        runHook postInstallIntermediates

        ${optionalString jsexe.shouldSymlink ''
          for jsexeDir in $installIntermediatesDir/build/*/*.jsexe; do
            bn=$(basename $jsexeDir)
            exe="''${bn%.jsexe}"
            (cd ${binDir} && ln -s $installIntermediatesDir/build/$exe/$exe.jsexe)
          done
        ''}
      '';

      passthru = passthru // rec {

        inherit pname version disallowGhcReference;

        compiler = ghc;

        # All this information is intended just for `shellFor`.  It should be
        # considered unstable and indeed we knew how to keep it private we would.
        getCabalDeps = {
          inherit
            buildDepends
            buildTools
            executableFrameworkDepends
            executableHaskellDepends
            executablePkgconfigDepends
            executableSystemDepends
            executableToolDepends
            extraLibraries
            libraryFrameworkDepends
            libraryHaskellDepends
            libraryPkgconfigDepends
            librarySystemDepends
            libraryToolDepends
            pkg-configDepends
            setupHaskellDepends
            ;
        }
        // lib.optionalAttrs doCheck {
          inherit
            testDepends
            testFrameworkDepends
            testHaskellDepends
            testPkgconfigDepends
            testSystemDepends
            testToolDepends
            ;
        }
        // lib.optionalAttrs doBenchmark {
          inherit
            benchmarkDepends
            benchmarkFrameworkDepends
            benchmarkHaskellDepends
            benchmarkPkgconfigDepends
            benchmarkSystemDepends
            benchmarkToolDepends
            ;
        };

        # Attributes for the old definition of `shellFor`. Should be removed but
        # this predates the warning at the top of `getCabalDeps`.
        getBuildInputs = rec {
          inherit propagatedBuildInputs otherBuildInputs allPkgconfigDepends;
          haskellBuildInputs = isHaskellPartition.right;
          systemBuildInputs = isHaskellPartition.wrong;
          isHaskellPartition = lib.partition isHaskellPkg (
            propagatedBuildInputs ++ otherBuildInputs ++ depsBuildBuild ++ nativeBuildInputs
          );
        };

        isHaskellLibrary = isLibrary;

        # TODO: ask why the split outputs are configurable at all?
        # TODO: include tests for split if possible
        # Given the haskell package, returns
        # the directory containing the haddock documentation.
        # `null' if no haddock documentation was built.
        # TODO: fetch the self from the fixpoint instead
        haddockDir = self: if doHaddock then "${docdir self.doc}/html" else null;

        # Creates a derivation containing all of the necessary dependencies for building the
        # parent derivation. The attribute set that it takes as input can be viewed as:
        #
        #    { withHoogle }
        #
        # The derivation that it builds contains no outpaths because it is meant for use
        # as an environment
        #
        #   # Example use
        #   # Creates a shell with all of the dependencies required to build the "hello" package,
        #   # and with python:
        #
        #   > nix-shell -E 'with (import <nixpkgs> {}); \
        #   >    haskellPackages.hello.envFunc { buildInputs = [ python ]; }'
        envFunc =
          {
            withHoogle ? false,
          }:
          let
            name = "ghc-shell-for-${drv.name}";

            withPackages = if withHoogle then ghcWithHoogle else ghcWithPackages;

            # We use the `ghcWithPackages` function from `buildHaskellPackages` if we
            # want a shell for the sake of cross compiling a package. In the native case
            # we don't use this at all, and instead put the setupDepends in the main
            # `ghcWithPackages`. This way we don't have two wrapper scripts called `ghc`
            # shadowing each other on the PATH.
            ghcEnvForBuild =
              assert isCross;
              buildHaskellPackages.ghcWithPackages (_: setupHaskellDepends);

            ghcEnv = withPackages (
              _: otherBuildInputsHaskell ++ propagatedBuildInputs ++ lib.optionals (!isCross) setupHaskellDepends
            );

            ghcCommandCaps = lib.toUpper ghcCommand';
          in
          runCommandCC name {
            inherit shellHook;

            depsBuildBuild = lib.optional isCross ghcEnvForBuild;
            nativeBuildInputs = [
              ghcEnv
            ]
            ++ optional (allPkgconfigDepends != [ ]) pkg-config
            ++ collectedToolDepends;
            buildInputs = otherBuildInputsSystem;

            env = {
              "NIX_${ghcCommandCaps}" = "${ghcEnv}/bin/${ghcCommand}";
              "NIX_${ghcCommandCaps}PKG" = "${ghcEnv}/bin/${ghcCommand}-pkg";
              # TODO: is this still valid?
              "NIX_${ghcCommandCaps}_DOCDIR" = "${ghcEnv}/share/doc/ghc/html";
              "NIX_${ghcCommandCaps}_LIBDIR" =
                if ghc.isHaLVM or false then "${ghcEnv}/lib/HaLVM-${ghc.version}" else "${ghcEnv}/${ghcLibdir}";
            }
            // optionalAttrs (stdenv.buildPlatform.libc == "glibc") {
              # TODO: Why is this written in terms of `buildPackages`, unlike
              # the outer `env`?
              #
              # According to @sternenseemann [1]:
              #
              # > The condition is based on `buildPlatform`, so it needs to
              # > match. `LOCALE_ARCHIVE` is set to accompany `LANG` which
              # > concerns things we execute on the build platform like
              # > `haddock`.
              # >
              # > Arguably the outer non `buildPackages` one is incorrect and
              # > probably works by accident in most cases since the locale
              # > archive is not platform specific (the trouble is that it
              # > may sometimes be impossible to cross-compile). At least
              # > that would be my assumption.
              #
              # [1]: https://github.com/NixOS/nixpkgs/pull/424368#discussion_r2202683378
              LOCALE_ARCHIVE = "${buildPackages.glibcLocales}/lib/locale/locale-archive";
            }
            // env';
          } "echo $nativeBuildInputs $buildInputs > $out";

        env = envFunc { };

      };

      meta = {
        inherit homepage platforms;
      }
      // optionalAttrs (args ? broken) { inherit broken; }
      // optionalAttrs (args ? description) { inherit description; }
      // optionalAttrs (args ? license) { inherit license; }
      // optionalAttrs (args ? maintainers) { inherit maintainers; }
      // optionalAttrs (args ? teams) { inherit teams; }
      // optionalAttrs (args ? hydraPlatforms) { inherit hydraPlatforms; }
      // optionalAttrs (args ? badPlatforms) { inherit badPlatforms; }
      // optionalAttrs (args ? changelog) { inherit changelog; }
      // optionalAttrs (args ? mainProgram) { inherit mainProgram; };

    }
    // optionalAttrs (args ? sourceRoot) { inherit sourceRoot; }
    // optionalAttrs (args ? setSourceRoot) { inherit setSourceRoot; }
    // optionalAttrs (args ? preCompileBuildDriver) { inherit preCompileBuildDriver; }
    // optionalAttrs (args ? postCompileBuildDriver) { inherit postCompileBuildDriver; }
    // optionalAttrs (args ? preUnpack) { inherit preUnpack; }
    // optionalAttrs (args ? postUnpack) { inherit postUnpack; }
    // optionalAttrs (args ? patches) { inherit patches; }
    // optionalAttrs (args ? patchPhase) { inherit patchPhase; }
    // optionalAttrs (args ? preConfigure) { inherit preConfigure; }
    // optionalAttrs (args ? postConfigure) { inherit postConfigure; }
    // optionalAttrs (args ? preBuild) { inherit preBuild; }
    // optionalAttrs (args ? postBuild) { inherit postBuild; }
    // optionalAttrs (args ? doBenchmark) { inherit doBenchmark; }
    // optionalAttrs (args ? checkPhase) { inherit checkPhase; }
    // optionalAttrs (args ? preCheck) { inherit preCheck; }
    // optionalAttrs (args ? postCheck) { inherit postCheck; }
    // optionalAttrs (args ? preHaddock) { inherit preHaddock; }
    // optionalAttrs (args ? postHaddock) { inherit postHaddock; }
    // optionalAttrs (args ? preInstall) { inherit preInstall; }
    // optionalAttrs (args ? installPhase) { inherit installPhase; }
    // optionalAttrs (args ? postInstall) { inherit postInstall; }
    // optionalAttrs (args ? preFixup) { inherit preFixup; }
    // optionalAttrs (args ? postFixup) { inherit postFixup; }
    // optionalAttrs (args ? dontStrip) { inherit dontStrip; }
    // optionalAttrs (postPhases != [ ]) { inherit postPhases; }
    // optionalAttrs (disallowedRequisites != [ ] || disallowGhcReference) {
      disallowedRequisites = disallowedRequisites ++ (if disallowGhcReference then [ ghc ] else [ ]);
    }
  )
)
