{ stdenv, buildPackages, buildHaskellPackages, ghc
, jailbreak-cabal, hscolour, cpphs, nodejs
, buildPlatform, hostPlatform
}:

let
  isCross = buildPlatform != hostPlatform;
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
, description ? ""
, doCheck ? !isCross && (stdenv.lib.versionOlder "7.4" ghc.version)
, doBenchmark ? false
, doHoogle ? true
, editedCabalFile ? null
, enableLibraryProfiling ? true
, enableExecutableProfiling ? false
, profilingDetail ? "all-functions"
# TODO enable shared libs for cross-compiling
, enableSharedExecutables ? false
, enableSharedLibraries ? ((ghc.isGhcjs or false) || stdenv.lib.versionOlder "7.7" ghc.version)
, enableDeadCodeElimination ? (!stdenv.isDarwin)  # TODO: use -dead_strip for darwin
, enableStaticLibraries ? true
, enableHsc2hsViaAsm ? hostPlatform.isWindows && stdenv.lib.versionAtLeast ghc.version "8.4"
, extraLibraries ? [], librarySystemDepends ? [], executableSystemDepends ? []
, homepage ? "http://hackage.haskell.org/package/${pname}"
, platforms ? with stdenv.lib.platforms; unix ++ windows # GHC can cross-compile
, hydraPlatforms ? null
, hyperlinkSource ? true
, isExecutable ? false, isLibrary ? !isExecutable
, jailbreak ? false
, license
, maintainers ? []
, doCoverage ? false
, doHaddock ? !(ghc.isHaLVM or false)
, passthru ? {}
, pkgconfigDepends ? [], libraryPkgconfigDepends ? [], executablePkgconfigDepends ? [], testPkgconfigDepends ? [], benchmarkPkgconfigDepends ? []
, testDepends ? [], testHaskellDepends ? [], testSystemDepends ? []
, benchmarkDepends ? [], benchmarkHaskellDepends ? [], benchmarkSystemDepends ? []
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
} @ args:

assert editedCabalFile != null -> revision != null;

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
  docdir = docoutput: docoutput + "/share/doc";

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

  hasActiveLibrary = isLibrary && (enableStaticLibraries || enableSharedLibraries || enableLibraryProfiling);

  # We cannot enable -j<n> parallelism for libraries because GHC is far more
  # likely to generate a non-determistic library ID in that case. Further
  # details are at <https://github.com/peti/ghc-library-id-bug>.
  enableParallelBuilding = (versionOlder "7.8" ghc.version && !hasActiveLibrary) || versionOlder "8.0.1" ghc.version;

  crossCabalFlags = [
    "--with-ghc=${ghc.targetPrefix}ghc"
    "--with-ghc-pkg=${ghc.targetPrefix}ghc-pkg"
    "--with-gcc=${stdenv.cc.targetPrefix}cc"
    "--with-ld=${stdenv.cc.bintools.targetPrefix}ld"
    # use the one that comes with the cross compiler.
    "--with-hsc2hs=${ghc.targetPrefix}hsc2hs"
    "--with-strip=${stdenv.cc.bintools.targetPrefix}strip"
  ] ++ optionals (!isHaLVM) [
    "--hsc2hs-option=--cross-compile"
    (optionalString enableHsc2hsViaAsm "--hsc2hs-option=--via-asm")
  ];

  crossCabalFlagsString =
    stdenv.lib.optionalString isCross (" " + stdenv.lib.concatStringsSep " " crossCabalFlags);

  defaultConfigureFlags = [
    "--verbose" "--prefix=$out" "--libdir=\\$prefix/lib/\\$compiler" "--libsubdir=\\$pkgid"
    (optionalString enableSeparateDataOutput "--datadir=$data/share/${ghc.name}")
    (optionalString enableSeparateDocOutput "--docdir=${docdir "$doc"}")
    "--with-gcc=$CC" # Clang won't work without that extra information.
    "--package-db=$packageConfDir"
    (optionalString (enableSharedExecutables && stdenv.isLinux) "--ghc-option=-optl=-Wl,-rpath=$out/lib/${ghc.name}/${pname}-${version}")
    (optionalString (enableSharedExecutables && stdenv.isDarwin) "--ghc-option=-optl=-Wl,-headerpad_max_install_names")
    (optionalString enableParallelBuilding "--ghc-option=-j$NIX_BUILD_CORES")
    (optionalString useCpphs "--with-cpphs=${cpphs}/bin/cpphs --ghc-options=-cpp --ghc-options=-pgmP${cpphs}/bin/cpphs --ghc-options=-optP--cpp")
    (enableFeature (enableDeadCodeElimination && !hostPlatform.isArm && !hostPlatform.isAarch64 && (versionAtLeast "8.0.1" ghc.version)) "split-objs")
    (enableFeature enableLibraryProfiling "library-profiling")
    (optionalString (enableExecutableProfiling || enableLibraryProfiling) "--profiling-detail=${profilingDetail}")
    (enableFeature enableExecutableProfiling (if versionOlder ghc.version "8" then "executable-profiling" else "profiling"))
    (enableFeature enableSharedLibraries "shared")
    (optionalString (versionAtLeast ghc.version "7.10") (enableFeature doCoverage "coverage"))
    (optionalString (versionOlder "8.4" ghc.version) (enableFeature enableStaticLibraries "static"))
    (optionalString (isGhcjs || versionOlder "7.4" ghc.version) (enableFeature enableSharedExecutables "executable-dynamic"))
    (optionalString (isGhcjs || versionOlder "7" ghc.version) (enableFeature doCheck "tests"))
    "--enable-library-vanilla"  # TODO: Should this be configurable?
    "--enable-library-for-ghci" # TODO: Should this be configurable?
  ] ++ optionals (enableDeadCodeElimination && (stdenv.lib.versionOlder "8.0.1" ghc.version)) [
     "--ghc-option=-split-sections"
  ] ++ optionals isGhcjs [
    "--ghcjs"
  ] ++ optionals isCross ([
    "--configure-option=--host=${hostPlatform.config}"
  ] ++ crossCabalFlags);

  setupCompileFlags = [
    (optionalString (!coreSetup) "-${nativePackageDbFlag}=$packageConfDir")
    (optionalString (isGhcjs || isHaLVM || versionOlder "7.8" ghc.version) "-j$NIX_BUILD_CORES")
    # https://github.com/haskell/cabal/issues/2398
    (optionalString (versionOlder "7.10" ghc.version && !isHaLVM) "-threaded")
  ];

  isHaskellPkg = x: (x ? pname) && (x ? version) && (x ? env);
  isSystemPkg = x: !isHaskellPkg x;

  allPkgconfigDepends = pkgconfigDepends ++ libraryPkgconfigDepends ++ executablePkgconfigDepends ++
                        optionals doCheck testPkgconfigDepends ++ optionals doBenchmark benchmarkPkgconfigDepends;

  nativeBuildInputs = [ ghc nativeGhc removeReferencesTo ] ++ optional (allPkgconfigDepends != []) pkgconfig ++
                      buildTools ++ libraryToolDepends ++ executableToolDepends;
  propagatedBuildInputs = buildDepends ++ libraryHaskellDepends ++ executableHaskellDepends;
  otherBuildInputs = setupHaskellDepends ++ extraLibraries ++ librarySystemDepends ++ executableSystemDepends ++
                     optionals (allPkgconfigDepends != []) allPkgconfigDepends ++
                     optionals doCheck (testDepends ++ testHaskellDepends ++ testSystemDepends ++ testToolDepends) ++
                     optionals doBenchmark (benchmarkDepends ++ benchmarkHaskellDepends ++ benchmarkSystemDepends ++ benchmarkToolDepends);
  allBuildInputs = propagatedBuildInputs ++ otherBuildInputs;

  haskellBuildInputs = stdenv.lib.filter isHaskellPkg allBuildInputs;
  systemBuildInputs = stdenv.lib.filter isSystemPkg allBuildInputs;

  ghcEnv = ghc.withPackages (p: haskellBuildInputs);

  setupCommand = "./Setup";

  ghcCommand' = if isGhcjs then "ghcjs" else "ghc";
  ghcCommand = "${ghc.targetPrefix}${ghcCommand'}";
  ghcCommandCaps= toUpper ghcCommand';

  nativeGhcCommand = "${nativeGhc.targetPrefix}ghc";

in

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

  inherit nativeBuildInputs;
  buildInputs = otherBuildInputs ++ optionals (!hasActiveLibrary) propagatedBuildInputs;
  propagatedBuildInputs = optionals hasActiveLibrary propagatedBuildInputs;

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
    ${optionalString (hasActiveLibrary && hyperlinkSource) "export PATH=${hscolour}/bin:$PATH"}

    packageConfDir="$TMPDIR/package.conf.d"
    mkdir -p $packageConfDir

    setupCompileFlags="${concatStringsSep " " setupCompileFlags}"
    configureFlags="${concatStringsSep " " defaultConfigureFlags} $configureFlags"

    # host.*Pkgs defined in stdenv/setup.hs
    for p in "''${pkgsHostHost[@]}" "''${pkgsHostTarget[@]}"; do
      if [ -d "$p/lib/${ghc.name}/package.conf.d" ]; then
        cp -f "$p/lib/${ghc.name}/package.conf.d/"*.conf $packageConfDir/
        continue
      fi
      if [ -d "$p/include" ]; then
        configureFlags+=" --extra-include-dirs=$p/include"
      fi
      if [ -d "$p/lib" ]; then
        configureFlags+=" --extra-lib-dirs=$p/lib"
      fi
    done
  ''
  # only use the links hack if we're actually building dylibs. otherwise, the
  # "dynamic-library-dirs" point to nonexistent paths, and the ln command becomes
  # "ln -s $out/lib/links", which tries to recreate the links dir and fails
  + (optionalString (stdenv.isDarwin && enableSharedLibraries) ''
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
    if ${gnugrep}/bin/egrep -q -z 'Warning:.*depends on multiple versions' "$NIX_BUILD_TOP/cabal-configure.log"; then
      echo >&2 "*** abort because of serious configure-time warning from Cabal"
      exit 1
    fi

    export GHC_PACKAGE_PATH="$packageConfDir:"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ${setupCommand} build ${buildTarget}${crossCabalFlagsString}
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    ${setupCommand} test ${testTarget}
    runHook postCheck
  '';

  haddockPhase = ''
    runHook preHaddock
    ${optionalString (doHaddock && hasActiveLibrary) ''
      ${setupCommand} haddock --html \
        ${optionalString doHoogle "--hoogle"} \
        ${optionalString (hasActiveLibrary && hyperlinkSource) "--hyperlink-source"}
    ''}
    runHook postHaddock
  '';

  installPhase = ''
    runHook preInstall

    ${if !hasActiveLibrary then "${setupCommand} install" else ''
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
    ''}
    ${optionalString isGhcjs ''
      for exeDir in "$out/bin/"*.jsexe; do
        exe="''${exeDir%.jsexe}"
        printWords '#!${nodejs}/bin/node' > "$exe"
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

    isHaskellLibrary = hasActiveLibrary;

    # TODO: ask why the split outputs are configurable at all?
    # TODO: include tests for split if possible
    # Given the haskell package, returns
    # the directory containing the haddock documentation.
    # `null' if no haddock documentation was built.
    # TODO: fetch the self from the fixpoint instead
    haddockDir = self: if doHaddock then "${docdir self.doc}/html" else null;

    env = stdenv.mkDerivation {
      name = "interactive-${pname}-${version}-environment";
      buildInputs = systemBuildInputs;
      nativeBuildInputs = [ ghcEnv ] ++ nativeBuildInputs;
      LANG = "en_US.UTF-8";
      LOCALE_ARCHIVE = optionalString (stdenv.hostPlatform.libc == "glibc") "${glibcLocales}/lib/locale/locale-archive";
      shellHook = ''
        export NIX_${ghcCommandCaps}="${ghcEnv}/bin/${ghcCommand}"
        export NIX_${ghcCommandCaps}PKG="${ghcEnv}/bin/${ghcCommand}-pkg"
        # TODO: is this still valid?
        export NIX_${ghcCommandCaps}_DOCDIR="${ghcEnv}/share/doc/ghc/html"
        ${if isHaLVM
            then ''export NIX_${ghcCommandCaps}_LIBDIR="${ghcEnv}/lib/HaLVM-${ghc.version}"''
            else ''export NIX_${ghcCommandCaps}_LIBDIR="${ghcEnv}/lib/${ghcCommand}-${ghc.version}"''}
        ${shellHook}
      '';
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
// optionalAttrs (doCheck)              { inherit doCheck; }
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
// optionalAttrs (buildPlatform.libc == "glibc"){ LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive"; }
)
