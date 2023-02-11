{ lib, stdenv, buildPackages, buildHaskellPackages, ghc
, jailbreak-cabal, hscolour, cpphs, nodejs
, ghcWithHoogle, ghcWithPackages
}:

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
  inherit (buildPackages)
    fetchurl removeReferencesTo
    pkg-config coreutils gnugrep gnused glibcLocales;
in

{ pname
# Note that ghc.isGhcjs != stdenv.hostPlatform.isGhcjs.
# ghc.isGhcjs implies that we are using ghcjs, a project separate from GHC.
# (mere) stdenv.hostPlatform.isGhcjs means that we are using GHC's JavaScript
# backend. The latter is a normal cross compilation backend and needs little
# special accomodation.
, dontStrip ? (ghc.isGhcjs or false || stdenv.hostPlatform.isGhcjs)
, version, revision ? null
, sha256 ? null
, src ? fetchurl { url = "mirror://hackage/${pname}-${version}.tar.gz"; inherit sha256; }
, buildDepends ? [], setupHaskellDepends ? [], libraryHaskellDepends ? [], executableHaskellDepends ? []
, buildTarget ? ""
, buildTools ? [], libraryToolDepends ? [], executableToolDepends ? [], testToolDepends ? [], benchmarkToolDepends ? []
, configureFlags ? []
, buildFlags ? []
, haddockFlags ? []
, description ? null
, doCheck ? !isCross && lib.versionOlder "7.4" ghc.version
, doBenchmark ? false
, doHoogle ? true
, doHaddockQuickjump ? doHoogle && lib.versionAtLeast ghc.version "8.6"
, editedCabalFile ? null
# aarch64 outputs otherwise exceed 2GB limit
, enableLibraryProfiling ? !(ghc.isGhcjs or stdenv.targetPlatform.isAarch64 or false)
, enableExecutableProfiling ? false
, profilingDetail ? "exported-functions"
# TODO enable shared libs for cross-compiling
, enableSharedExecutables ? false
, enableSharedLibraries ? !stdenv.hostPlatform.isStatic && (ghc.enableShared or false)
, enableDeadCodeElimination ? (!stdenv.isDarwin)  # TODO: use -dead_strip for darwin
, enableStaticLibraries ? !(stdenv.hostPlatform.isWindows or stdenv.hostPlatform.isWasm)
, enableHsc2hsViaAsm ? stdenv.hostPlatform.isWindows && lib.versionAtLeast ghc.version "8.4"
, extraLibraries ? [], librarySystemDepends ? [], executableSystemDepends ? []
# On macOS, statically linking against system frameworks is not supported;
# see https://developer.apple.com/library/content/qa/qa1118/_index.html
# They must be propagated to the environment of any executable linking with the library
, libraryFrameworkDepends ? [], executableFrameworkDepends ? []
, homepage ? "https://hackage.haskell.org/package/${pname}"
, platforms ? with lib.platforms; all # GHC can cross-compile
, badPlatforms ? lib.platforms.none
, hydraPlatforms ? null
, hyperlinkSource ? true
, isExecutable ? false, isLibrary ? !isExecutable
, jailbreak ? false
, license
, enableParallelBuilding ? true
, maintainers ? null
, changelog ? null
, mainProgram ? null
, doCoverage ? false
, doHaddock ? !(ghc.isHaLVM or false) && (ghc.hasHaddock or true)
, doHaddockInterfaces ? doHaddock && lib.versionAtLeast ghc.version "9.0.1"
, passthru ? {}
, pkg-configDepends ? [], libraryPkgconfigDepends ? [], executablePkgconfigDepends ? [], testPkgconfigDepends ? [], benchmarkPkgconfigDepends ? []
, testDepends ? [], testHaskellDepends ? [], testSystemDepends ? [], testFrameworkDepends ? []
, benchmarkDepends ? [], benchmarkHaskellDepends ? [], benchmarkSystemDepends ? [], benchmarkFrameworkDepends ? []
, testTarget ? "", testFlags ? []
, broken ? false
, preCompileBuildDriver ? null, postCompileBuildDriver ? null
, preUnpack ? null, postUnpack ? null
, patches ? null, patchPhase ? null, prePatch ? "", postPatch ? ""
, preConfigure ? null, postConfigure ? null
, preBuild ? null, postBuild ? null
, preHaddock ? null, postHaddock ? null
, installPhase ? null, preInstall ? null, postInstall ? null
, checkPhase ? null, preCheck ? null, postCheck ? null
, preFixup ? null, postFixup ? null
, shellHook ? ""
, coreSetup ? false # Use only core packages to build Setup.hs.
, useCpphs ? false
, hardeningDisable ? null
, enableSeparateBinOutput ? false
, enableSeparateDataOutput ? false
, enableSeparateDocOutput ? doHaddock
, # Don't fail at configure time if there are multiple versions of the
  # same package in the (recursive) dependencies of the package being
  # built. Will delay failures, if any, to compile time.
  allowInconsistentDependencies ? false
, maxBuildCores ? 16 # more cores usually don't improve performance: https://ghc.haskell.org/trac/ghc/ticket/9221
, # If set to true, this builds a pre-linked .o file for this Haskell library.
  # This can make it slightly faster to load this library into GHCi, but takes
  # extra disk space and compile time.
  enableLibraryForGhci ? false
} @ args:

assert editedCabalFile != null -> revision != null;

# --enable-static does not work on windows. This is a bug in GHC.
# --enable-static will pass -staticlib to ghc, which only works for mach-o and elf.
assert stdenv.hostPlatform.isWindows -> enableStaticLibraries == false;
assert stdenv.hostPlatform.isWasm -> enableStaticLibraries == false;

let

  inherit (lib) optional optionals optionalString versionOlder versionAtLeast
                       concatStringsSep enableFeature optionalAttrs;

  isGhcjs = ghc.isGhcjs or false;
  isHaLVM = ghc.isHaLVM or false;
  packageDbFlag = if isGhcjs || isHaLVM || versionOlder "7.6" ghc.version
                  then "package-db"
                  else "package-conf";

  # GHC used for building Setup.hs
  #
  # Same as our GHC, unless we're cross, in which case it is native GHC with the
  # same version, or ghcjs, in which case its the ghc used to build ghcjs.
  nativeGhc = buildHaskellPackages.ghc;
  nativePackageDbFlag = if versionOlder "7.6" nativeGhc.version
                        then "package-db"
                        else "package-conf";

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
    # Pass the "wrong" C compiler rather than none at all so packages that just
    # use the C preproccessor still work, see
    # https://github.com/haskell/cabal/issues/6466 for details.
    "--with-gcc=${if stdenv.hasCC then "$CC" else "$CC_FOR_BUILD"}"
  ] ++ optionals stdenv.hasCC [
    "--with-ld=${stdenv.cc.bintools.targetPrefix}ld"
    "--with-ar=${stdenv.cc.bintools.targetPrefix}ar"
    # use the one that comes with the cross compiler.
    "--with-hsc2hs=${ghc.targetPrefix}hsc2hs"
    "--with-strip=${stdenv.cc.bintools.targetPrefix}strip"
  ] ++ optionals (!isHaLVM) [
    "--hsc2hs-option=--cross-compile"
    (optionalString enableHsc2hsViaAsm "--hsc2hs-option=--via-asm")
  ] ++ optional (allPkgconfigDepends != [])
    "--with-pkg-config=${pkg-config.targetPrefix}pkg-config";

  parallelBuildingFlags = "-j$NIX_BUILD_CORES" + optionalString stdenv.isLinux " +RTS -A64M -RTS";

  crossCabalFlagsString =
    lib.optionalString isCross (" " + lib.concatStringsSep " " crossCabalFlags);

  buildFlagsString = optionalString (buildFlags != []) (" " + concatStringsSep " " buildFlags);

  defaultConfigureFlags = [
    "--verbose"
    "--prefix=$out"
    "--libdir=\\$prefix/lib/\\$compiler"
    "--libsubdir=\\$abi/\\$libname"
    (optionalString enableSeparateDataOutput "--datadir=$data/share/${ghcNameWithPrefix}")
    (optionalString enableSeparateDocOutput "--docdir=${docdir "$doc"}")
  ] ++ optionals stdenv.hasCC [
    "--with-gcc=$CC" # Clang won't work without that extra information.
  ] ++ [
    "--package-db=$packageConfDir"
    (optionalString (enableSharedExecutables && stdenv.isLinux) "--ghc-option=-optl=-Wl,-rpath=$out/lib/${ghcNameWithPrefix}/${pname}-${version}")
    (optionalString (enableSharedExecutables && stdenv.isDarwin) "--ghc-option=-optl=-Wl,-headerpad_max_install_names")
    (optionalString enableParallelBuilding "--ghc-options=${parallelBuildingFlags}")
    (optionalString useCpphs "--with-cpphs=${cpphs}/bin/cpphs --ghc-options=-cpp --ghc-options=-pgmP${cpphs}/bin/cpphs --ghc-options=-optP--cpp")
    (enableFeature (enableDeadCodeElimination && !stdenv.hostPlatform.isAarch32 && !stdenv.hostPlatform.isAarch64 && (versionAtLeast "8.0.1" ghc.version)) "split-objs")
    (enableFeature enableLibraryProfiling "library-profiling")
    (optionalString ((enableExecutableProfiling || enableLibraryProfiling) && versionOlder "8" ghc.version) "--profiling-detail=${profilingDetail}")
    (enableFeature enableExecutableProfiling (if versionOlder ghc.version "8" then "executable-profiling" else "profiling"))
    (enableFeature enableSharedLibraries "shared")
    (optionalString (versionAtLeast ghc.version "7.10") (enableFeature doCoverage "coverage"))
    (optionalString (versionOlder "8.4" ghc.version) (enableFeature enableStaticLibraries "static"))
    (optionalString (isGhcjs || versionOlder "7.4" ghc.version) (enableFeature enableSharedExecutables "executable-dynamic"))
    (optionalString (isGhcjs || versionOlder "7" ghc.version) (enableFeature doCheck "tests"))
    (enableFeature doBenchmark "benchmarks")
    "--enable-library-vanilla"  # TODO: Should this be configurable?
    (enableFeature enableLibraryForGhci "library-for-ghci")
  ] ++ optionals (enableDeadCodeElimination && (lib.versionOlder "8.0.1" ghc.version)) [
     "--ghc-option=-split-sections"
  ] ++ optionals dontStrip [
    "--disable-library-stripping"
    "--disable-executable-stripping"
  ] ++ optionals isGhcjs [
    "--ghcjs"
  ] ++ optionals isCross ([
    "--configure-option=--host=${stdenv.hostPlatform.config}"
  ] ++ crossCabalFlags
  ) ++ optionals enableSeparateBinOutput [
    "--bindir=${binDir}"
  ] ++ optionals (doHaddockInterfaces && isLibrary) [
    "--ghc-options=-haddock"
  ];

  setupCompileFlags = [
    (optionalString (!coreSetup) "-${nativePackageDbFlag}=$setupPackageConfDir")
    (optionalString enableParallelBuilding (parallelBuildingFlags))
    "-threaded"       # https://github.com/haskell/cabal/issues/2398
    "-rtsopts"        # allow us to pass RTS flags to the generated Setup executable
  ];

  isHaskellPkg = x: x ? isHaskellLibrary;

  allPkgconfigDepends = pkg-configDepends ++ libraryPkgconfigDepends ++ executablePkgconfigDepends ++
                        optionals doCheck testPkgconfigDepends ++ optionals doBenchmark benchmarkPkgconfigDepends;

  depsBuildBuild = [ nativeGhc ]
    # CC_FOR_BUILD may be necessary if we have no C preprocessor for the host
    # platform. See crossCabalFlags above for more details.
    ++ lib.optionals (!stdenv.hasCC) [ buildPackages.stdenv.cc ];
  collectedToolDepends =
    buildTools ++ libraryToolDepends ++ executableToolDepends ++
    optionals doCheck testToolDepends ++
    optionals doBenchmark benchmarkToolDepends;
  nativeBuildInputs =
    [ ghc removeReferencesTo ] ++ optional (allPkgconfigDepends != []) pkg-config ++
    setupHaskellDepends ++ collectedToolDepends;
  propagatedBuildInputs = buildDepends ++ libraryHaskellDepends ++ executableHaskellDepends ++ libraryFrameworkDepends;
  otherBuildInputsHaskell =
    optionals doCheck (testDepends ++ testHaskellDepends) ++
    optionals doBenchmark (benchmarkDepends ++ benchmarkHaskellDepends);
  otherBuildInputsSystem =
    extraLibraries ++ librarySystemDepends ++ executableSystemDepends ++ executableFrameworkDepends ++
    allPkgconfigDepends ++
    optionals doCheck (testSystemDepends ++ testFrameworkDepends) ++
    optionals doBenchmark (benchmarkSystemDepends ++ benchmarkFrameworkDepends);
  # TODO next rebuild just define as `otherBuildInputsHaskell ++ otherBuildInputsSystem`
  otherBuildInputs =
    extraLibraries ++ librarySystemDepends ++ executableSystemDepends ++ executableFrameworkDepends ++
    allPkgconfigDepends ++
    optionals doCheck (testDepends ++ testHaskellDepends ++ testSystemDepends ++ testFrameworkDepends) ++
    optionals doBenchmark (benchmarkDepends ++ benchmarkHaskellDepends ++ benchmarkSystemDepends ++ benchmarkFrameworkDepends);

  setupCommand = "./Setup";

  ghcCommand' = if isGhcjs then "ghcjs" else "ghc";
  ghcCommand = "${ghc.targetPrefix}${ghcCommand'}";

  ghcNameWithPrefix = "${ghc.targetPrefix}${ghc.haskellCompilerName}";

  nativeGhcCommand = "${nativeGhc.targetPrefix}ghc";

  buildPkgDb = ghcName: packageConfDir: ''
    # If this dependency has a package database, then copy the contents of it,
    # unless it is one of our GHCs. These can appear in our dependencies when
    # we are doing native builds, and they have package databases in them, but
    # we do not want to copy them over.
    #
    # We don't need to, since those packages will be provided by the GHC when
    # we compile with it, and doing so can result in having multiple copies of
    # e.g. Cabal in the database with the same name and version, which is
    # ambiguous.
    if [ -d "$p/lib/${ghcName}/package.conf.d" ] && [ "$p" != "${ghc}" ] && [ "$p" != "${nativeGhc}" ]; then
      cp -f "$p/lib/${ghcName}/package.conf.d/"*.conf ${packageConfDir}/
      continue
    fi
  '';
in lib.fix (drv:

assert allPkgconfigDepends != [] -> pkg-config != null;

stdenv.mkDerivation ({
  inherit pname version;

  outputs = [ "out" ]
         ++ (optional enableSeparateDataOutput "data")
         ++ (optional enableSeparateDocOutput "doc")
         ++ (optional enableSeparateBinOutput "bin");
  setOutputFlags = false;

  pos = builtins.unsafeGetAttrPos "pname" args;

  prePhases = ["setupCompilerEnvironmentPhase"];
  preConfigurePhases = ["compileBuildDriverPhase"];
  preInstallPhases = ["haddockPhase"];

  inherit src;

  inherit depsBuildBuild nativeBuildInputs;
  buildInputs = otherBuildInputs ++ optionals (!isLibrary) propagatedBuildInputs
    # For patchShebangsAuto in fixupPhase
    ++ optionals stdenv.hostPlatform.isGhcjs [ nodejs ];
  propagatedBuildInputs = optionals isLibrary propagatedBuildInputs;

  LANG = "en_US.UTF-8";         # GHC needs the locale configured during the Haddock phase.

  prePatch = optionalString (editedCabalFile != null) ''
    echo "Replace Cabal file with edited version from ${newCabalFileUrl}."
    cp ${newCabalFile} ${pname}.cabal
  '' + prePatch;

  postPatch = optionalString jailbreak ''
    echo "Run jailbreak-cabal to lift version restrictions on build inputs."
    ${jailbreak-cabal}/bin/jailbreak-cabal ${pname}.cabal
  '' + postPatch;

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
      ${buildPkgDb "${nativeGhcCommand}-${nativeGhc.version}" "$setupPackageConfDir"}
    done
    ${nativeGhcCommand}-pkg --${nativePackageDbFlag}="$setupPackageConfDir" recache
  ''
  # For normal components
  + ''
    for p in "''${pkgsHostHost[@]}" "''${pkgsHostTarget[@]}"; do
      ${buildPkgDb ghcNameWithPrefix "$packageConfDir"}
      if [ -d "$p/include" ]; then
        configureFlags+=" --extra-include-dirs=$p/include"
      fi
      if [ -d "$p/lib" ]; then
        configureFlags+=" --extra-lib-dirs=$p/lib"
      fi
    ''
    # It is not clear why --extra-framework-dirs does work fine on Linux
    + optionalString (!stdenv.buildPlatform.isDarwin || versionAtLeast nativeGhc.version "8.0") ''
      if [[ -d "$p/Library/Frameworks" ]]; then
        configureFlags+=" --extra-framework-dirs=$p/Library/Frameworks"
      fi
  '' + ''
    done
  ''
  # only use the links hack if we're actually building dylibs. otherwise, the
  # "dynamic-library-dirs" point to nonexistent paths, and the ln command becomes
  # "ln -s $out/lib/links", which tries to recreate the links dir and fails
  + (optionalString (stdenv.isDarwin && (enableSharedLibraries || enableSharedExecutables)) ''
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
  '') + ''
    ${ghcCommand}-pkg --${packageDbFlag}="$packageConfDir" recache

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
  configurePlatforms = [];
  inherit configureFlags;

  # Note: the options here must be always added, regardless of whether the
  # package specifies `hardeningDisable`.
  hardeningDisable = lib.optionals (args ? hardeningDisable) hardeningDisable
    ++ lib.optional (ghc.isHaLVM or false) "all"
    # Static libraries (ie. all of pkgsStatic.haskellPackages) fail to build
    # because by default Nix adds `-pie` to the linker flags: this
    # conflicts with the `-r` and `-no-pie` flags added by GHC (see
    # https://gitlab.haskell.org/ghc/ghc/-/issues/19580). hardeningDisable
    # changes the default Nix behavior regarding adding "hardening" flags.
    ++ lib.optional enableStaticLibraries "pie";

  configurePhase = ''
    runHook preConfigure

    unset GHC_PACKAGE_PATH      # Cabal complains if this variable is set during configure.

    echo configureFlags: $configureFlags
    ${setupCommand} configure $configureFlags 2>&1 | ${coreutils}/bin/tee "$NIX_BUILD_TOP/cabal-configure.log"
    ${lib.optionalString (!allowInconsistentDependencies) ''
      if ${gnugrep}/bin/egrep -q -z 'Warning:.*depends on multiple versions' "$NIX_BUILD_TOP/cabal-configure.log"; then
        echo >&2 "*** abort because of serious configure-time warning from Cabal"
        exit 1
      fi
    ''}
    export GHC_PACKAGE_PATH="$packageConfDir:"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ${setupCommand} build ${buildTarget}${crossCabalFlagsString}${buildFlagsString}
    runHook postBuild
  '';

  inherit doCheck;

  # Run test suite(s) and pass `checkFlags` as well as `checkFlagsArray`.
  # `testFlags` are added to `checkFlagsArray` each prefixed with
  # `--test-option`, so Cabal passes it to the underlying test suite binary.
  checkPhase = ''
    runHook preCheck
    checkFlagsArray+=(
      "--show-details=streaming"
      ${lib.escapeShellArgs (builtins.map (opt: "--test-option=${opt}") testFlags)}
    )
    ${setupCommand} test ${testTarget} $checkFlags ''${checkFlagsArray:+"''${checkFlagsArray[@]}"}
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

    ${if !isLibrary && buildTarget == "" then "${setupCommand} install"
      # ^^ if the project is not a library, and no build target is specified, we can just use "install".
      else if !isLibrary then "${setupCommand} copy ${buildTarget}"
      # ^^ if the project is not a library, and we have a build target, then use "copy" to install
      # just the target specified; "install" will error here, since not all targets have been built.
    else ''
      ${setupCommand} copy ${buildTarget}
      local packageConfDir="$out/lib/${ghcNameWithPrefix}/package.conf.d"
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
    ''}
    ${optionalString isGhcjs ''
      for exeDir in "${binDir}/"*.jsexe; do
        exe="''${exeDir%.jsexe}"
        printWords '#!${nodejs}/bin/node' > "$exe"
        echo >> "$exe"
        cat "$exeDir/all.js" >> "$exe"
        chmod +x "$exe"
      done
    ''}
    ${optionalString doCoverage "mkdir -p $out/share && cp -r dist/hpc $out/share"}
    ${optionalString (enableSharedExecutables && isExecutable && !isGhcjs && stdenv.isDarwin && lib.versionOlder ghc.version "7.10") ''
      for exe in "${binDir}/"* ; do
        install_name_tool -add_rpath "$out/lib/ghc-${ghc.version}/${pname}-${version}" "$exe"
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

  passthru = passthru // rec {

    inherit pname version;

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
    } // lib.optionalAttrs doCheck {
      inherit
        testDepends
        testFrameworkDepends
        testHaskellDepends
        testPkgconfigDepends
        testSystemDepends
        testToolDepends
        ;
    } // lib.optionalAttrs doBenchmark {
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
      isHaskellPartition = lib.partition
        isHaskellPkg
        (propagatedBuildInputs ++ otherBuildInputs ++ depsBuildBuild ++ nativeBuildInputs);
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
    #   >    haskell.packages.ghc865.hello.envFunc { buildInputs = [ python ]; }'
    envFunc = { withHoogle ? false }:
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

        ghcEnv = withPackages (_:
          otherBuildInputsHaskell ++
          propagatedBuildInputs ++
          lib.optionals (!isCross) setupHaskellDepends);

        ghcCommandCaps = lib.toUpper ghcCommand';
      in stdenv.mkDerivation ({
        inherit name shellHook;

        depsBuildBuild = lib.optional isCross ghcEnvForBuild;
        nativeBuildInputs =
          [ ghcEnv ] ++ optional (allPkgconfigDepends != []) pkg-config ++
          collectedToolDepends;
        buildInputs =
          otherBuildInputsSystem;
        phases = ["installPhase"];
        installPhase = "echo $nativeBuildInputs $buildInputs > $out";
        LANG = "en_US.UTF-8";
        LOCALE_ARCHIVE = lib.optionalString (stdenv.hostPlatform.libc == "glibc") "${buildPackages.glibcLocales}/lib/locale/locale-archive";
        "NIX_${ghcCommandCaps}" = "${ghcEnv}/bin/${ghcCommand}";
        "NIX_${ghcCommandCaps}PKG" = "${ghcEnv}/bin/${ghcCommand}-pkg";
        # TODO: is this still valid?
        "NIX_${ghcCommandCaps}_DOCDIR" = "${ghcEnv}/share/doc/ghc/html";
        "NIX_${ghcCommandCaps}_LIBDIR" = if ghc.isHaLVM or false
          then "${ghcEnv}/lib/HaLVM-${ghc.version}"
          else "${ghcEnv}/lib/${ghcCommand}-${ghc.version}";
      });

    env = envFunc { };

  };

  meta = { inherit homepage license platforms; }
         // optionalAttrs (args ? broken)         { inherit broken; }
         // optionalAttrs (args ? description)    { inherit description; }
         // optionalAttrs (args ? maintainers)    { inherit maintainers; }
         // optionalAttrs (args ? hydraPlatforms) { inherit hydraPlatforms; }
         // optionalAttrs (args ? badPlatforms)   { inherit badPlatforms; }
         // optionalAttrs (args ? changelog)      { inherit changelog; }
         // optionalAttrs (args ? mainProgram)    { inherit mainProgram; }
         ;

}
// optionalAttrs (args ? preCompileBuildDriver)  { inherit preCompileBuildDriver; }
// optionalAttrs (args ? postCompileBuildDriver) { inherit postCompileBuildDriver; }
// optionalAttrs (args ? preUnpack)              { inherit preUnpack; }
// optionalAttrs (args ? postUnpack)             { inherit postUnpack; }
// optionalAttrs (args ? patches)                { inherit patches; }
// optionalAttrs (args ? patchPhase)             { inherit patchPhase; }
// optionalAttrs (args ? preConfigure)           { inherit preConfigure; }
// optionalAttrs (args ? postConfigure)          { inherit postConfigure; }
// optionalAttrs (args ? preBuild)               { inherit preBuild; }
// optionalAttrs (args ? postBuild)              { inherit postBuild; }
// optionalAttrs (args ? doBenchmark)            { inherit doBenchmark; }
// optionalAttrs (args ? checkPhase)             { inherit checkPhase; }
// optionalAttrs (args ? preCheck)               { inherit preCheck; }
// optionalAttrs (args ? postCheck)              { inherit postCheck; }
// optionalAttrs (args ? preHaddock)             { inherit preHaddock; }
// optionalAttrs (args ? postHaddock)            { inherit postHaddock; }
// optionalAttrs (args ? preInstall)             { inherit preInstall; }
// optionalAttrs (args ? installPhase)           { inherit installPhase; }
// optionalAttrs (args ? postInstall)            { inherit postInstall; }
// optionalAttrs (args ? preFixup)               { inherit preFixup; }
// optionalAttrs (args ? postFixup)              { inherit postFixup; }
// optionalAttrs (args ? dontStrip)              { inherit dontStrip; }
// optionalAttrs (stdenv.buildPlatform.libc == "glibc"){ LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive"; }
)
)
