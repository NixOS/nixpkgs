{ stdenv, fetchurl, ghc, pkgconfig, glibcLocales, coreutils, gnugrep, gnused
, jailbreak-cabal, hscolour, cpphs, withPackagesBuilder
}:

{ pname
, version
, sha256 ? null
, src ? fetchurl { url = "mirror://hackage/${pname}-${version}.tar.gz"; inherit sha256; }
, buildDepends ? []
, buildTarget ? ""
, buildTools ? []
, configureFlags ? []
, description ? ""
, doCheck ? stdenv.lib.versionOlder "7.4" ghc.version
, doHoogle ? true
, editedCabalFile ? null
, enableLibraryProfiling ? false
, enableSharedExecutables ? stdenv.lib.versionOlder "7.7" ghc.version
, enableSharedLibraries ? stdenv.lib.versionOlder "7.7" ghc.version
, enableSplitObjs ? !stdenv.isDarwin # http://hackage.haskell.org/trac/ghc/ticket/4013
, enableStaticLibraries ? true
, extraLibraries ? []
, homepage ? "http://hackage.haskell.org/package/${pname}"
, hydraPlatforms ? ghc.meta.hydraPlatforms or ghc.meta.platforms
, hyperlinkSource ? true
, isExecutable ? false, isLibrary ? !isExecutable
, jailbreak ? false
, license
, maintainers ? []
, doHaddock ? true
, passthru ? {}
, pkgconfigDepends ? []
, platforms ? ghc.meta.platforms
, testDepends ? []
, testTarget ? ""
, broken ? false
, preUnpack ? "", postUnpack ? ""
, patches ? [], patchPhase ? "", prePatch ? "", postPatch ? ""
, preConfigure ? "", postConfigure ? ""
, preBuild ? "", postBuild ? ""
, preInstall ? "", postInstall ? ""
, checkPhase ? "", preCheck ? "", postCheck ? ""
, preFixup ? "", postFixup ? ""
, coreSetup ? false # Use only core packages to build Setup.hs.
, useCpphs ? false
}:

assert pkgconfigDepends != [] -> pkgconfig != null;

let

  inherit (stdenv.lib) optional optionals optionalString versionOlder
                       concatStringsSep enableFeature optionalAttrs;

  newCabalFile = fetchurl {
    url = "http://hackage.haskell.org/package/${pname}-${version}/${pname}.cabal";
    sha256 = editedCabalFile;
  };

  defaultSetupHs = builtins.toFile "Setup.hs" ''
                     import Distribution.Simple
                     main = defaultMain
                   '';

  hasActiveLibrary = isLibrary && (enableStaticLibraries || enableSharedLibraries || enableLibraryProfiling);

  enableParallelBuilding = versionOlder "7.8" ghc.version && !hasActiveLibrary;

  defaultConfigureFlags = [
    "--verbose" "--prefix=$out" "--libdir=\\$prefix/lib/\\$compiler" "--libsubdir=\\$pkgid"
    "--with-gcc=$CC"            # Clang won't work without that extra information.
    (optionalString (enableSharedExecutables && stdenv.isLinux) "--ghc-option=-optl=-Wl,-rpath=$out/lib/${ghc.name}/${pname}-${version}")
    (optionalString (enableSharedExecutables && stdenv.isDarwin) "--ghc-option=-optl=-Wl,-headerpad_max_install_names")
    (optionalString enableParallelBuilding "--ghc-option=-j$NIX_BUILD_CORES")
    (optionalString useCpphs "--with-cpphs=${cpphs}/bin/cpphs --ghc-options=-cpp --ghc-options=-pgmP${cpphs}/bin/cpphs --ghc-options=-optP--cpp")
    (enableFeature enableSplitObjs "split-objs")
    (enableFeature enableLibraryProfiling "library-profiling")
    (enableFeature enableSharedLibraries "shared")
    (optionalString (versionOlder "7" ghc.version) (enableFeature enableStaticLibraries "library-vanilla"))
    (optionalString (versionOlder "7.4" ghc.version) (enableFeature enableSharedExecutables "executable-dynamic"))
    (optionalString (versionOlder "7" ghc.version) (enableFeature doCheck "tests"))
  ] ++ extraLibFlags ++ extraIncludeFlags;

  setupCompileFlags = [
    (optionalString (versionOlder "7.8" ghc.version) "-j$NIX_BUILD_CORES")
  ];
  setupCompiler = if coreSetup then "${ghc}/bin/ghc" else "ghc";

  isHaskellPkg = x: (x ? pname) && (x ? version);
  isSystemPkg = x: !isHaskellPkg x;

  propagatedBuildInputs = buildDepends;
  systemLibraries = extraLibraries ++
                    optionals (pkgconfigDepends != []) ([pkgconfig] ++ pkgconfigDepends);
  otherBuildInputs = systemLibraries ++
                     buildTools ++
                     optionals doCheck testDepends;
  allBuildInputs = propagatedBuildInputs ++ otherBuildInputs;

  haskellBuildInputs = stdenv.lib.filter isHaskellPkg allBuildInputs;
  haskellBuildInputsClosure = stdenv.lib.filter isHaskellPkg (stdenv.lib.closePropagation allBuildInputs);
  systemBuildInputs = stdenv.lib.filter isSystemPkg allBuildInputs;

  # Note: cannot use builtins.pathExists here because that doesn't work for strings
  # with contexts.
  hasSubPath = path: sub: builtins.readDir path ? ${sub};
  subPaths = subs: with stdenv.lib;
    concatMap (path: map (sub: path + "/" + sub) (filter (hasSubPath path) subs));
  extraIncludeDirs = subPaths ["include"] systemLibraries;
  extraLibDirs = subPaths ["lib" "lib64"] systemLibraries;
  extraIncludeFlags = map (x: "--extra-include-dirs=" + x) extraIncludeDirs;
  extraLibFlags = map (x: "--extra-lib-dirs=" + x) extraLibDirs;

in
stdenv.mkDerivation ({
  name = "${optionalString hasActiveLibrary "haskell-"}${pname}-${version}";

  prePhases = ["setupCompilerEnvironmentPhase"];
  preConfigurePhases = ["jailbreakPhase" "compileBuildDriverPhase"];
  preInstallPhases = ["haddockPhase"];

  inherit src;

  nativeBuildInputs = otherBuildInputs ++ optionals (!hasActiveLibrary) propagatedBuildInputs;
  propagatedNativeBuildInputs = optionals hasActiveLibrary propagatedBuildInputs;

  LANG = "en_US.UTF-8";         # GHC needs the locale configured during the Haddock phase.
  LOCALE_ARCHIVE = optionalString stdenv.isLinux "${glibcLocales}/lib/locale/locale-archive";

  setupCompilerEnvironmentPhase = ''
    runHook preSetupCompilerEnvironment

    echo "Building with ${ghc}."
    ghcDir=$(mktemp -d)/ghc
    local realout="$out"
    export out=$ghcDir
    ${withPackagesBuilder { 
      paths = haskellBuildInputsClosure; 
      ignoreCollisions = false; 
    }}
    export out=$realout

    export PATH="$ghcDir/bin:$PATH"
    ${optionalString (hasActiveLibrary && hyperlinkSource) "export PATH=${hscolour}/bin:$PATH"}
    setupCompileFlags="${stdenv.lib.concatStringsSep " " setupCompileFlags}"
    configureFlags="${stdenv.lib.concatStringsSep " " defaultConfigureFlags} $configureFlags"

    runHook postSetupCompilerEnvironment
  '';

  jailbreakPhase = ''
    runHook preJailbreak

    ${optionalString (editedCabalFile != null) ''
      echo "Replacing Cabal file with edited version ${newCabalFile}."
      cp ${newCabalFile} ${pname}.cabal
    ''}
    ${optionalString jailbreak ''
      echo "Running jailbreak-cabal to lift version restrictions on build inputs."
      ${jailbreak-cabal}/bin/jailbreak-cabal ${pname}.cabal
    ''}

    runHook postJailbreak
  '';

  compileBuildDriverPhase = ''
    runHook preCompileBuildDriver

    for i in Setup.hs Setup.lhs ${defaultSetupHs}; do
      test -f $i && break
    done

    echo setupCompileFlags: $setupCompileFlags
    ${setupCompiler} $setupCompileFlags --make -o Setup -odir $TMPDIR -hidir $TMPDIR $i

    runHook postCompileBuildDriver
  '';

  configurePhase = ''
    runHook preConfigure

    echo configureFlags: $configureFlags
    ./Setup configure $configureFlags 2>&1 | ${coreutils}/bin/tee "$NIX_BUILD_TOP/cabal-configure.log"
    if ${gnugrep}/bin/egrep -q '^Warning:.*depends on multiple versions' "$NIX_BUILD_TOP/cabal-configure.log"; then
      echo >&2 "*** abort because of serious configure-time warning from Cabal"
      exit 1
    fi

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ./Setup build ${buildTarget}
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    ./Setup test ${testTarget}
    runHook postCheck
  '';

  haddockPhase = ''
    runHook preHaddock
    ${optionalString (doHaddock && hasActiveLibrary) ''
      ./Setup haddock --html \
        ${optionalString doHoogle "--hoogle"} \
        ${optionalString (hasActiveLibrary && hyperlinkSource) "--hyperlink-source"}
    ''}
    runHook postHaddock
  '';

  installPhase = ''
    runHook preInstall

    ./Setup copy
    ${optionalString hasActiveLibrary ''
      local packageConfDir="$out/lib/${ghc.name}/package.conf.d"
      local packageConfFile="$packageConfDir/${pname}-${version}.conf"
      mkdir -p "$packageConfDir"
      ./Setup register --gen-pkg-config=$packageConfFile
      local pkgId=$( ${gnused}/bin/sed -n -e 's|^id: ||p' $packageConfFile )
      mv $packageConfFile $packageConfDir/$pkgId.conf
    ''}

    ${optionalString (enableSharedExecutables && isExecutable && stdenv.isDarwin) ''
      for exe in "$out/bin/"* ; do
        install_name_tool -add_rpath "$out/lib/ghc-${ghc.version}/${pname}-${version}" "$exe"
      done
    ''}

    runHook postInstall
  '';

  shellHook = ''
    runHook setupCompilerEnvironmentPhase
  '';

  passthru = passthru // { inherit pname version; };

  meta = { inherit homepage license platforms; }
         // optionalAttrs broken               { inherit broken; }
         // optionalAttrs (description != "")  { inherit description; }
         // optionalAttrs (maintainers != [])  { inherit maintainers; }
         // optionalAttrs (hydraPlatforms != platforms) { inherit hydraPlatforms; }
         ;

}
// optionalAttrs (preUnpack != "")      { inherit preUnpack; }
// optionalAttrs (postUnpack != "")     { inherit postUnpack; }
// optionalAttrs (configureFlags != []) { inherit configureFlags; }
// optionalAttrs (patches != [])        { inherit patches; }
// optionalAttrs (patchPhase != "")     { inherit patchPhase; }
// optionalAttrs (prePatch != "")       { inherit prePatch; }
// optionalAttrs (postPatch != "")      { inherit postPatch; }
// optionalAttrs (preConfigure != "")   { inherit preConfigure; }
// optionalAttrs (postConfigure != "")  { inherit postConfigure; }
// optionalAttrs (preBuild != "")       { inherit preBuild; }
// optionalAttrs (postBuild != "")      { inherit postBuild; }
// optionalAttrs (doCheck)              { inherit doCheck; }
// optionalAttrs (checkPhase != "")     { inherit checkPhase; }
// optionalAttrs (preCheck != "")       { inherit preCheck; }
// optionalAttrs (postCheck != "")      { inherit postCheck; }
// optionalAttrs (preInstall != "")     { inherit preInstall; }
// optionalAttrs (postInstall != "")    { inherit postInstall; }
// optionalAttrs (preFixup != "")       { inherit preFixup; }
// optionalAttrs (postFixup != "")      { inherit postFixup; }
)
