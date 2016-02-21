{ stdenv, fetchurl, ghc, pkgconfig, glibcLocales, coreutils, gnugrep, gnused
, jailbreak-cabal, hscolour, cpphs
}:

{ pname
, dontStrip ? (ghc.isGhcjs or false)
, version, revision ? null
, sha256 ? null
, src ? fetchurl { url = "mirror://hackage/${pname}-${version}.tar.gz"; inherit sha256; }
, buildDepends ? [], libraryHaskellDepends ? [], executableHaskellDepends ? []
, buildTarget ? ""
, buildTools ? [], libraryToolDepends ? [], executableToolDepends ? [], testToolDepends ? []
, configureFlags ? []
, description ? ""
, doCheck ? stdenv.lib.versionOlder "7.4" ghc.version
, doHoogle ? true
, editedCabalFile ? null
, enableLibraryProfiling ? false
, enableExecutableProfiling ? false
, enableSharedExecutables ? ((ghc.isGhcjs or false) || stdenv.lib.versionOlder "7.7" ghc.version)
, enableSharedLibraries ? ((ghc.isGhcjs or false) || stdenv.lib.versionOlder "7.7" ghc.version)
, enableSplitObjs ? !stdenv.isDarwin # http://hackage.haskell.org/trac/ghc/ticket/4013
, enableStaticLibraries ? true
, extraLibraries ? [], librarySystemDepends ? [], executableSystemDepends ? []
, homepage ? "http://hackage.haskell.org/package/${pname}"
, platforms ? ghc.meta.platforms
, hydraPlatforms ? platforms
, hyperlinkSource ? true
, isExecutable ? false, isLibrary ? !isExecutable
, jailbreak ? false
, license
, maintainers ? []
, doHaddock ? !stdenv.isDarwin || stdenv.lib.versionAtLeast ghc.version "7.8"
, passthru ? {}
, pkgconfigDepends ? [], libraryPkgconfigDepends ? [], executablePkgconfigDepends ? [], testPkgconfigDepends ? []
, testDepends ? [], testHaskellDepends ? [], testSystemDepends ? []
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
} @ args:

assert editedCabalFile != null -> revision != null;

let

  inherit (stdenv.lib) optional optionals optionalString versionOlder
                       concatStringsSep enableFeature optionalAttrs toUpper;

  isGhcjs = ghc.isGhcjs or false;
  nativeGhc = if isGhcjs then ghc.nativeGhc else ghc;

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

  ghc76xOrLater = isGhcjs || stdenv.lib.versionOlder "7.6" ghc.version;
  packageDbFlag = if ghc76xOrLater then "package-db" else "package-conf";

  hasActiveLibrary = isLibrary && (enableStaticLibraries || enableSharedLibraries || enableLibraryProfiling);

  # We cannot enable -j<n> parallelism for libraries because GHC is far more
  # likely to generate a non-determistic library ID in that case. Further
  # details are at <https://github.com/peti/ghc-library-id-bug>.
  enableParallelBuilding = versionOlder "7.8" ghc.version && !hasActiveLibrary;

  defaultConfigureFlags = [
    "--verbose" "--prefix=$out" "--libdir=\\$prefix/lib/\\$compiler" "--libsubdir=\\$pkgid"
    "--with-gcc=$CC"            # Clang won't work without that extra information.
    "--package-db=$packageConfDir"
    (optionalString (enableSharedExecutables && stdenv.isLinux) "--ghc-option=-optl=-Wl,-rpath=$out/lib/${ghc.name}/${pname}-${version}")
    (optionalString (enableSharedExecutables && stdenv.isDarwin) "--ghc-option=-optl=-Wl,-headerpad_max_install_names")
    (optionalString enableParallelBuilding "--ghc-option=-j$NIX_BUILD_CORES")
    (optionalString useCpphs "--with-cpphs=${cpphs}/bin/cpphs --ghc-options=-cpp --ghc-options=-pgmP${cpphs}/bin/cpphs --ghc-options=-optP--cpp")
    (enableFeature enableSplitObjs "split-objs")
    (enableFeature enableLibraryProfiling "library-profiling")
    (enableFeature enableExecutableProfiling (if versionOlder ghc.version "8" then "executable-profiling" else "profiling"))
    (enableFeature enableSharedLibraries "shared")
    (optionalString (isGhcjs || versionOlder "7" ghc.version) (enableFeature enableStaticLibraries "library-vanilla"))
    (optionalString (isGhcjs || versionOlder "7.4" ghc.version) (enableFeature enableSharedExecutables "executable-dynamic"))
    (optionalString (isGhcjs || versionOlder "7" ghc.version) (enableFeature doCheck "tests"))
  ] ++ optionals isGhcjs [
    "--with-hsc2hs=${ghc.nativeGhc}/bin/hsc2hs"
    "--ghcjs"
  ];

  setupCompileFlags = [
    (optionalString (!coreSetup) "-${packageDbFlag}=$packageConfDir")
    (optionalString (isGhcjs || versionOlder "7.8" ghc.version) "-j$NIX_BUILD_CORES")
    (optionalString (versionOlder "7.10" ghc.version) "-threaded") # https://github.com/haskell/cabal/issues/2398
  ];

  isHaskellPkg = x: (x ? pname) && (x ? version) && (x ? env);
  isSystemPkg = x: !isHaskellPkg x;

  allPkgconfigDepends = pkgconfigDepends ++ libraryPkgconfigDepends ++ executablePkgconfigDepends ++
                        optionals doCheck testPkgconfigDepends;

  propagatedBuildInputs = buildDepends ++ libraryHaskellDepends ++ executableHaskellDepends;
  otherBuildInputs = extraLibraries ++ librarySystemDepends ++ executableSystemDepends ++
                     buildTools ++ libraryToolDepends ++ executableToolDepends ++
                     optionals (allPkgconfigDepends != []) ([pkgconfig] ++ allPkgconfigDepends) ++
                     optionals doCheck (testDepends ++ testHaskellDepends ++ testSystemDepends ++ testToolDepends);
  allBuildInputs = propagatedBuildInputs ++ otherBuildInputs;

  haskellBuildInputs = stdenv.lib.filter isHaskellPkg allBuildInputs;
  systemBuildInputs = stdenv.lib.filter isSystemPkg allBuildInputs;

  ghcEnv = ghc.withPackages (p: haskellBuildInputs);

  setupBuilder = if isGhcjs then "${nativeGhc}/bin/ghc" else ghcCommand;
  setupCommand = "./Setup";
  ghcCommand = if isGhcjs then "ghcjs" else "ghc";
  ghcCommandCaps = toUpper ghcCommand;

in

assert allPkgconfigDepends != [] -> pkgconfig != null;

stdenv.mkDerivation ({
  name = "${pname}-${version}";

  pos = builtins.unsafeGetAttrPos "pname" args;

  prePhases = ["setupCompilerEnvironmentPhase"];
  preConfigurePhases = ["compileBuildDriverPhase"];
  preInstallPhases = ["haddockPhase"];

  inherit src;

  nativeBuildInputs = otherBuildInputs ++ optionals (!hasActiveLibrary) propagatedBuildInputs;
  propagatedNativeBuildInputs = optionals hasActiveLibrary propagatedBuildInputs;

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
    export PATH="${ghc}/bin:$PATH"
    ${optionalString (hasActiveLibrary && hyperlinkSource) "export PATH=${hscolour}/bin:$PATH"}

    packageConfDir="$TMPDIR/package.conf.d"
    mkdir -p $packageConfDir

    setupCompileFlags="${concatStringsSep " " setupCompileFlags}"
    configureFlags="${concatStringsSep " " defaultConfigureFlags} $configureFlags"

    local inputClosure=""
    for i in $propagatedNativeBuildInputs $nativeBuildInputs; do
      findInputs $i inputClosure propagated-native-build-inputs
    done
    for p in $inputClosure; do
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
    ${ghcCommand}-pkg --${packageDbFlag}="$packageConfDir" recache

    runHook postSetupCompilerEnvironment
  '';

  compileBuildDriverPhase = ''
    runHook preCompileBuildDriver

    for i in Setup.hs Setup.lhs ${defaultSetupHs}; do
      test -f $i && break
    done

    echo setupCompileFlags: $setupCompileFlags
    ${setupBuilder} $setupCompileFlags --make -o Setup -odir $TMPDIR -hidir $TMPDIR $i

    runHook postCompileBuildDriver
  '';

  configurePhase = ''
    runHook preConfigure

    unset GHC_PACKAGE_PATH      # Cabal complains if this variable is set during configure.

    echo configureFlags: $configureFlags
    ${setupCommand} configure $configureFlags 2>&1 | ${coreutils}/bin/tee "$NIX_BUILD_TOP/cabal-configure.log"
    if ${gnugrep}/bin/egrep -q '^Warning:.*depends on multiple versions' "$NIX_BUILD_TOP/cabal-configure.log"; then
      echo >&2 "*** abort because of serious configure-time warning from Cabal"
      exit 1
    fi

    export GHC_PACKAGE_PATH="$packageConfDir:"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ${setupCommand} build ${buildTarget}
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
      local pkgId=$( ${gnused}/bin/sed -n -e 's|^id: ||p' $packageConfFile )
      mv $packageConfFile $packageConfDir/$pkgId.conf
    ''}

    ${optionalString (enableSharedExecutables && isExecutable && !isGhcjs && stdenv.isDarwin && stdenv.lib.versionOlder ghc.version "7.10") ''
      for exe in "$out/bin/"* ; do
        install_name_tool -add_rpath "$out/lib/ghc-${ghc.version}/${pname}-${version}" "$exe"
      done
    ''}

    runHook postInstall
  '';

  passthru = passthru // {

    inherit pname version;

    isHaskellLibrary = hasActiveLibrary;

    env = stdenv.mkDerivation {
      name = "interactive-${pname}-${version}-environment";
      nativeBuildInputs = [ ghcEnv systemBuildInputs ];
      LANG = "en_US.UTF-8";
      LOCALE_ARCHIVE = optionalString stdenv.isLinux "${glibcLocales}/lib/locale/locale-archive";
      shellHook = ''
        export NIX_${ghcCommandCaps}="${ghcEnv}/bin/${ghcCommand}"
        export NIX_${ghcCommandCaps}PKG="${ghcEnv}/bin/${ghcCommand}-pkg"
        export NIX_${ghcCommandCaps}_DOCDIR="${ghcEnv}/share/doc/ghc/html"
        export NIX_${ghcCommandCaps}_LIBDIR="${ghcEnv}/lib/${ghcEnv.name}"
        ${shellHook}
      '';
    };

  };

  meta = { inherit homepage license platforms; }
         // optionalAttrs broken               { inherit broken; }
         // optionalAttrs (description != "")  { inherit description; }
         // optionalAttrs (maintainers != [])  { inherit maintainers; }
         // optionalAttrs (hydraPlatforms != platforms) { inherit hydraPlatforms; }
         ;

}
// optionalAttrs (preCompileBuildDriver != "")  { inherit preCompileBuildDriver; }
// optionalAttrs (postCompileBuildDriver != "") { inherit postCompileBuildDriver; }
// optionalAttrs (preUnpack != "")      { inherit preUnpack; }
// optionalAttrs (postUnpack != "")     { inherit postUnpack; }
// optionalAttrs (configureFlags != []) { inherit configureFlags; }
// optionalAttrs (patches != [])        { inherit patches; }
// optionalAttrs (patchPhase != "")     { inherit patchPhase; }
// optionalAttrs (preConfigure != "")   { inherit preConfigure; }
// optionalAttrs (postConfigure != "")  { inherit postConfigure; }
// optionalAttrs (preBuild != "")       { inherit preBuild; }
// optionalAttrs (postBuild != "")      { inherit postBuild; }
// optionalAttrs (doCheck)              { inherit doCheck; }
// optionalAttrs (checkPhase != "")     { inherit checkPhase; }
// optionalAttrs (preCheck != "")       { inherit preCheck; }
// optionalAttrs (postCheck != "")      { inherit postCheck; }
// optionalAttrs (preInstall != "")     { inherit preInstall; }
// optionalAttrs (installPhase != "")   { inherit installPhase; }
// optionalAttrs (postInstall != "")    { inherit postInstall; }
// optionalAttrs (preFixup != "")       { inherit preFixup; }
// optionalAttrs (postFixup != "")      { inherit postFixup; }
// optionalAttrs (dontStrip)            { inherit dontStrip; }
// optionalAttrs (stdenv.isLinux)       { LOCALE_ARCHIVE = "${glibcLocales}/lib/locale/locale-archive"; }
)
