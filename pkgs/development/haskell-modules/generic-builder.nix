{ stdenv, buildPackages, buildHaskellPackages, ghc
, jailbreak-cabal, hscolour, cpphs, nodejs, shellFor
}:

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;
  inherit (buildPackages)
    fetchurl removeReferencesTo
    pkgconfig coreutils gnugrep gnused glibcLocales;
in

{ pname
, dontStrip ? (ghc.isGhcjs or false)
, version, revision ? null
, sha256 ? null
, src ? fetchurl { url = "mirror://hackage/${pname}-${version}.tar.gz"; inherit sha256; }
, buildDepends ? [], setupHaskellDepends ? [], libraryHaskellDepends ? [], executableHaskellDepends ? []
, buildTarget ? ""
, buildTools ? [], libraryToolDepends ? [], executableToolDepends ? [], testToolDepends ? [], benchmarkToolDepends ? []
, configureFlags ? []
, buildFlags ? []
, description ? ""
, doCheck ? !isCross && stdenv.lib.versionOlder "7.4" ghc.version
, doBenchmark ? false
, doHoogle ? true
, editedCabalFile ? null
, enableLibraryProfiling ? true
, enableExecutableProfiling ? false
, profilingDetail ? "exported-functions"
# TODO enable shared libs for cross-compiling
, enableSharedExecutables ? false
, enableSharedLibraries ? (ghc.enableShared or false)
, enableDeadCodeElimination ? (!stdenv.isDarwin)  # TODO: use -dead_strip for darwin
, enableStaticLibraries ? !stdenv.hostPlatform.isWindows
, enableHsc2hsViaAsm ? stdenv.hostPlatform.isWindows && stdenv.lib.versionAtLeast ghc.version "8.4"
, extraLibraries ? [], librarySystemDepends ? [], executableSystemDepends ? []
# On macOS, statically linking against system frameworks is not supported;
# see https://developer.apple.com/library/content/qa/qa1118/_index.html
# They must be propagated to the environment of any executable linking with the library
, libraryFrameworkDepends ? [], executableFrameworkDepends ? []
, homepage ? "https://hackage.haskell.org/package/${pname}"
, platforms ? with stdenv.lib.platforms; unix ++ windows # GHC can cross-compile
, hydraPlatforms ? null
, hyperlinkSource ? true
, isExecutable ? false, isLibrary ? !isExecutable
, jailbreak ? false
, license
# We cannot enable -j<n> parallelism for libraries because GHC is far more
# likely to generate a non-determistic library ID in that case. Further
# details are at <https://github.com/peti/ghc-library-id-bug>.
#
# Currently disabled for aarch64. See https://ghc.haskell.org/trac/ghc/ticket/15449.
, enableParallelBuilding ? ((stdenv.lib.versionOlder "7.8" ghc.version && !isLibrary) || stdenv.lib.versionOlder "8.0.1" ghc.version) && !(stdenv.buildPlatform.isAarch64)
, maintainers ? []
, doCoverage ? false
, doHaddock ? !(ghc.isHaLVM or false)
, passthru ? {}
, pkgconfigDepends ? [], libraryPkgconfigDepends ? [], executablePkgconfigDepends ? [], testPkgconfigDepends ? [], benchmarkPkgconfigDepends ? []
, testDepends ? [], testHaskellDepends ? [], testSystemDepends ? [], testFrameworkDepends ? []
, benchmarkDepends ? [], benchmarkHaskellDepends ? [], benchmarkSystemDepends ? [], benchmarkFrameworkDepends ? []
, testTarget ? ""
, broken ? false
, preCompileBuildDriver ? "", postCompileBuildDriver ? ""
, preUnpack ? "", postUnpack ? ""
, patches ? [], patchPhase ? "", prePatch ? "", postPatch ? ""
, preConfigure ? "", postConfigure ? ""
, preBuild ? "", postBuild ? ""
, installPhase ? "", preInstall ? "", postInstall ? ""
, checkPhase ? "", preCheck ? "", postCheck ? ""
, preFixup ? "", postFixup ? ""
, shellHook ? ""
, coreSetup ? false # Use only core packages to build Setup.hs.
, useCpphs ? false
, hardeningDisable ? stdenv.lib.optional (ghc.isHaLVM or false) "all"
, enableSeparateDataOutput ? false
, enableSeparateDocOutput ? doHaddock
, # Don't fail at configure time if there are multiple versions of the
  # same package in the (recursive) dependencies of the package being
  # built. Will delay failures, if any, to compile time.
  allowInconsistentDependencies ? false
} @ args:

assert editedCabalFile != null -> revision != null;

# --enable-static does not work on windows. This is a bug in GHC.
# --enable-static will pass -staticlib to ghc, which only works for mach-o and elf.
assert stdenv.hostPlatform.isWindows -> enableStaticLibraries == false;

let

  inherit (stdenv.lib) optional optionals optionalString versionOlder versionAtLeast
                       concatStringsSep enableFeature optionalAttrs toUpper;

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

  newCabalFileUrl = "http://hackage.haskell.org/package/${pname}-${version}/revision/${revision}.cabal";
  newCabalFile = fetchurl {
    url = newCabalFileUrl;
    sha256 = editedCabalFile;
    name = "${pname}-${version}-r${revision}.cabal";
  };

  defaultSetupHs = builtins.toFile "Setup.hs" ''
                     import Distribution.Simple
                     main = defaultMain
                   '';

  crossCabalFlags = [
    "--with-ghc=${ghc.targetPrefix}ghc"
    "--with-ghc-pkg=${ghc.targetPrefix}ghc-pkg"
    "--with-gcc=${stdenv.cc.targetPrefix}cc"
    "--with-ld=${stdenv.cc.bintools.targetPrefix}ld"
    "--with-ar=${stdenv.cc.bintools.targetPrefix}ar"
    # use the one that comes with the cross compiler.
    "--with-hsc2hs=${ghc.targetPrefix}hsc2hs"
    "--with-strip=${stdenv.cc.bintools.targetPrefix}strip"
  ] ++ optionals (!isHaLVM) [
    "--hsc2hs-option=--cross-compile"
    (optionalString enableHsc2hsViaAsm "--hsc2hs-option=--via-asm")
  ];

  crossCabalFlagsString =
    stdenv.lib.optionalString isCross (" " + stdenv.lib.concatStringsSep " " crossCabalFlags);

  buildFlagsString = optionalString (buildFlags != []) (" " + concatStringsSep " " buildFlags);

  defaultConfigureFlags = [
    "--verbose" "--prefix=$out" "--libdir=\\$prefix/lib/\\$compiler" "--libsubdir=\\$abi/\\$libname"
    (optionalString enableSeparateDataOutput "--datadir=$data/share/${ghc.name}")
    (optionalString enableSeparateDocOutput "--docdir=${docdir "$doc"}")
    "--with-gcc=$CC" # Clang won't work without that extra information.
    "--package-db=$packageConfDir"
    (optionalString (enableSharedExecutables && stdenv.isLinux) "--ghc-option=-optl=-Wl,-rpath=$out/lib/${ghc.name}/${pname}-${version}")
    (optionalString (enableSharedExecutables && stdenv.isDarwin) "--ghc-option=-optl=-Wl,-headerpad_max_install_names")
    (optionalString enableParallelBuilding "--ghc-option=-j$NIX_BUILD_CORES")
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
    "--enable-library-for-ghci" # TODO: Should this be configurable?
  ] ++ optionals (enableDeadCodeElimination && (stdenv.lib.versionOlder "8.0.1" ghc.version)) [
     "--ghc-option=-split-sections"
  ] ++ optionals dontStrip [
    "--disable-library-stripping"
    "--disable-executable-stripping"
  ] ++ optionals isGhcjs [
    "--ghcjs"
  ] ++ optionals isCross ([
    "--configure-option=--host=${stdenv.hostPlatform.config}"
  ] ++ crossCabalFlags);

  setupCompileFlags = [
    (optionalString (!coreSetup) "-${nativePackageDbFlag}=$setupPackageConfDir")
    (optionalString (isGhcjs || isHaLVM || versionOlder "7.8" ghc.version) "-j$NIX_BUILD_CORES")
    # https://github.com/haskell/cabal/issues/2398
    (optionalString (versionOlder "7.10" ghc.version && !isHaLVM) "-threaded")
  ];

  isHaskellPkg = x: x ? isHaskellLibrary;

  allPkgconfigDepends = pkgconfigDepends ++ libraryPkgconfigDepends ++ executablePkgconfigDepends ++
                        optionals doCheck testPkgconfigDepends ++ optionals doBenchmark benchmarkPkgconfigDepends;

  depsBuildBuild = [ nativeGhc ];
  nativeBuildInputs = [ ghc removeReferencesTo ] ++ optional (allPkgconfigDepends != []) pkgconfig ++
                      setupHaskellDepends ++
                      buildTools ++ libraryToolDepends ++ executableToolDepends ++
                      optionals doCheck testToolDepends ++
                      optionals doBenchmark benchmarkToolDepends;
  propagatedBuildInputs = buildDepends ++ libraryHaskellDepends ++ executableHaskellDepends ++ libraryFrameworkDepends;
  otherBuildInputs = extraLibraries ++ librarySystemDepends ++ executableSystemDepends ++ executableFrameworkDepends ++
                     allPkgconfigDepends ++
                     optionals doCheck (testDepends ++ testHaskellDepends ++ testSystemDepends ++ testFrameworkDepends) ++
                     optionals doBenchmark (benchmarkDepends ++ benchmarkHaskellDepends ++ benchmarkSystemDepends ++ benchmarkFrameworkDepends);


  allBuildInputs = propagatedBuildInputs ++ otherBuildInputs ++ depsBuildBuild ++ nativeBuildInputs;
  isHaskellPartition =
    stdenv.lib.partition isHaskellPkg allBuildInputs;

  setupCommand = "./Setup";

  ghcCommand' = if isGhcjs then "ghcjs" else "ghc";
  ghcCommand = "${ghc.targetPrefix}${ghcCommand'}";

  nativeGhcCommand = "${nativeGhc.targetPrefix}ghc";

  buildPkgDb = ghcName: packageConfDir: ''
    if [ -d "$p/lib/${ghcName}/package.conf.d" ]; then
      cp -f "$p/lib/${ghcName}/package.conf.d/"*.conf ${packageConfDir}/
      continue
    fi
  '';
in stdenv.lib.fix (drv:

assert allPkgconfigDepends != [] -> pkgconfig != null;

stdenv.mkDerivation ({
  name = "${pname}-${version}";

  outputs = [ "out" ] ++ (optional enableSeparateDataOutput "data") ++ (optional enableSeparateDocOutput "doc");
  setOutputFlags = false;

  pos = builtins.unsafeGetAttrPos "pname" args;

  prePhases = ["setupCompilerEnvironmentPhase"];
  preConfigurePhases = ["compileBuildDriverPhase"];
  preInstallPhases = ["haddockPhase"];

  inherit src;

  inherit depsBuildBuild nativeBuildInputs;
  buildInputs = otherBuildInputs ++ optionals (!isLibrary) propagatedBuildInputs;
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
    runHook preSetupCompilerEnvironment

    echo "Build with ${ghc}."
    ${optionalString (isLibrary && hyperlinkSource) "export PATH=${hscolour}/bin:$PATH"}

    setupPackageConfDir="$TMPDIR/setup-package.conf.d"
    mkdir -p $setupPackageConfDir
    packageConfDir="$TMPDIR/package.conf.d"
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
      ${buildPkgDb nativeGhc.name "$setupPackageConfDir"}
    done
    ${nativeGhcCommand}-pkg --${nativePackageDbFlag}="$setupPackageConfDir" recache
  ''
  # For normal components
  + ''
    for p in "''${pkgsHostHost[@]}" "''${pkgsHostTarget[@]}"; do
      ${buildPkgDb ghc.name "$packageConfDir"}
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
    for d in $(grep dynamic-library-dirs "$packageConfDir/"*|awk '{print $2}'|sort -u); do
      ln -s "$d/"*.dylib $dynamicLinksDir
    done
    # Edit the local package DB to reference the links directory.
    for f in "$packageConfDir/"*.conf; do
      sed -i "s,dynamic-library-dirs: .*,dynamic-library-dirs: $dynamicLinksDir," $f
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
    ${nativeGhcCommand} $setupCompileFlags --make -o Setup -odir $TMPDIR -hidir $TMPDIR $i

    runHook postCompileBuildDriver
  '';

  # Cabal takes flags like `--configure-option=--host=...` instead
  configurePlatforms = [];
  inherit configureFlags;

  configurePhase = ''
    runHook preConfigure

    unset GHC_PACKAGE_PATH      # Cabal complains if this variable is set during configure.

    echo configureFlags: $configureFlags
    ${setupCommand} configure $configureFlags 2>&1 | ${coreutils}/bin/tee "$NIX_BUILD_TOP/cabal-configure.log"
    ${stdenv.lib.optionalString (!allowInconsistentDependencies) ''
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

  checkPhase = ''
    runHook preCheck
    ${setupCommand} test ${testTarget}
    runHook postCheck
  '';

  haddockPhase = ''
    runHook preHaddock
    ${optionalString (doHaddock && isLibrary) ''
      ${setupCommand} haddock --html \
        ${optionalString doHoogle "--hoogle"} \
        ${optionalString (isLibrary && hyperlinkSource) "--hyperlink-source"}
    ''}
    runHook postHaddock
  '';

  installPhase = ''
    runHook preInstall

    ${if !isLibrary then "${setupCommand} install" else ''
      ${setupCommand} copy
      local packageConfDir="$out/lib/${ghc.name}/package.conf.d"
      local packageConfFile="$packageConfDir/${pname}-${version}.conf"
      mkdir -p "$packageConfDir"
      ${setupCommand} register --gen-pkg-config=$packageConfFile
      if [ -d "$packageConfFile" ]; then
        mv "$packageConfFile/"* "$packageConfDir"
        rmdir "$packageConfFile"
      fi
      for packageConfFile in "$packageConfDir/"*; do
        local pkgId=$( ${gnused}/bin/sed -n -e 's|^id: ||p' $packageConfFile )
        mv $packageConfFile $packageConfDir/$pkgId.conf
      done

      # delete confdir if there are no libraries
      find $packageConfDir -maxdepth 0 -empty -delete;
    ''}
    ${optionalString isGhcjs ''
      for exeDir in "$out/bin/"*.jsexe; do
        exe="''${exeDir%.jsexe}"
        printWords '#!${nodejs}/bin/node' > "$exe"
        echo >> "$exe"
        cat "$exeDir/all.js" >> "$exe"
        chmod +x "$exe"
      done
    ''}
    ${optionalString doCoverage "mkdir -p $out/share && cp -r dist/hpc $out/share"}
    ${optionalString (enableSharedExecutables && isExecutable && !isGhcjs && stdenv.isDarwin && stdenv.lib.versionOlder ghc.version "7.10") ''
      for exe in "$out/bin/"* ; do
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

  passthru = passthru // {

    inherit pname version;

    compiler = ghc;


    getBuildInputs = {
      inherit propagatedBuildInputs otherBuildInputs allPkgconfigDepends;
      haskellBuildInputs = isHaskellPartition.right;
      systemBuildInputs = isHaskellPartition.wrong;
    };

    isHaskellLibrary = isLibrary;

    # TODO: ask why the split outputs are configurable at all?
    # TODO: include tests for split if possible
    # Given the haskell package, returns
    # the directory containing the haddock documentation.
    # `null' if no haddock documentation was built.
    # TODO: fetch the self from the fixpoint instead
    haddockDir = self: if doHaddock then "${docdir self.doc}/html" else null;

    env = shellFor {
      packages = p: [ drv ];
      inherit shellHook;
    };

  };

  meta = { inherit homepage license platforms; }
         // optionalAttrs broken               { inherit broken; }
         // optionalAttrs (description != "")  { inherit description; }
         // optionalAttrs (maintainers != [])  { inherit maintainers; }
         // optionalAttrs (hydraPlatforms != null) { inherit hydraPlatforms; }
         ;

}
// optionalAttrs (preCompileBuildDriver != "")  { inherit preCompileBuildDriver; }
// optionalAttrs (postCompileBuildDriver != "") { inherit postCompileBuildDriver; }
// optionalAttrs (preUnpack != "")      { inherit preUnpack; }
// optionalAttrs (postUnpack != "")     { inherit postUnpack; }
// optionalAttrs (patches != [])        { inherit patches; }
// optionalAttrs (patchPhase != "")     { inherit patchPhase; }
// optionalAttrs (preConfigure != "")   { inherit preConfigure; }
// optionalAttrs (postConfigure != "")  { inherit postConfigure; }
// optionalAttrs (preBuild != "")       { inherit preBuild; }
// optionalAttrs (postBuild != "")      { inherit postBuild; }
// optionalAttrs (doBenchmark)          { inherit doBenchmark; }
// optionalAttrs (checkPhase != "")     { inherit checkPhase; }
// optionalAttrs (preCheck != "")       { inherit preCheck; }
// optionalAttrs (postCheck != "")      { inherit postCheck; }
// optionalAttrs (preInstall != "")     { inherit preInstall; }
// optionalAttrs (installPhase != "")   { inherit installPhase; }
// optionalAttrs (postInstall != "")    { inherit postInstall; }
// optionalAttrs (preFixup != "")       { inherit preFixup; }
// optionalAttrs (postFixup != "")      { inherit postFixup; }
// optionalAttrs (dontStrip)            { inherit dontStrip; }
// optionalAttrs (hardeningDisable != []) { inherit hardeningDisable; }
// optionalAttrs (stdenv.buildPlatform.libc == "glibc"){ LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive"; }
)
)
