{ stdenv, fetchurl, ghc, pkgconfig, glibcLocales, coreutils, gnugrep, gnused
, jailbreak-cabal, hscolour
}:

{ pname
, version
, sha256 ? null
, src ? fetchurl { url = "mirror://hackage/${pname}-${version}.tar.gz"; inherit sha256; }
, buildDepends ? []
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
, noHaddock ? false
, passthru ? {}
, pkgconfigDepends ? []
, platforms ? ghc.meta.platforms
, testDepends ? []
, testTarget ? ""
, broken ? false
, patches ? [], patchPhase ? "", prePatch ? "", postPatch ? ""
, preConfigure ? "", postConfigure ? ""
, preBuild ? "", postBuild ? ""
, preInstall ? "", postInstall ? ""
, checkPhase ? "", preCheck ? "", postCheck ? ""
, preFixup ? "", postFixup ? ""
, coreSetup ? false # Use core packages to build Setup.hs
}:

assert pkgconfigDepends != [] -> pkgconfig != null;

let

  inherit (stdenv.lib) optional optionals optionalString versionOlder
                       concatStringsSep enableFeature optionalAttrs;

  defaultSetupHs = builtins.toFile "Setup.hs" ''
                     import Distribution.Simple
                     main = defaultMain
                   '';

  defaultConfigureFlags = [
    (enableFeature enableSplitObjs "split-objs")
    (enableFeature enableLibraryProfiling "library-profiling")
    (enableFeature enableSharedLibraries "shared")
    (optionalString (versionOlder "7" ghc.version) (enableFeature enableStaticLibraries "library-vanilla"))
    (optionalString (versionOlder "7.4" ghc.version) (enableFeature enableSharedExecutables "executable-dynamic"))
    (optionalString (versionOlder "7" ghc.version) (enableFeature doCheck "tests"))
  ];

  hasActiveLibrary = isLibrary && (enableStaticLibraries || enableSharedLibraries);

  newCabalFile = fetchurl {
    url = "http://hackage.haskell.org/package/${pname}-${version}/${pname}.cabal";
    sha256 = editedCabalFile;
  };

  isHaskellPkg = x: (x ? pname) && (x ? version);
  isSystemPkg = x: !isHaskellPkg x;

  allBuildInputs = stdenv.lib.filter (x: x != null) (
                     buildDepends ++ extraLibraries ++ buildTools ++
                     optionals (pkgconfigDepends != []) ([pkgconfig] ++ pkgconfigDepends) ++
                     optionals doCheck testDepends
                   );
  haskellBuildInputs = stdenv.lib.filter isHaskellPkg allBuildInputs;
  systemBuildInputs = stdenv.lib.filter isSystemPkg allBuildInputs;

  ghcEnv = ghc.withPackages (p: haskellBuildInputs);

in
stdenv.mkDerivation ({
  name = "${optionalString hasActiveLibrary "haskell-"}${pname}-${version}";

  inherit src;

  nativeBuildInputs = extraLibraries ++ buildTools ++
    optionals (pkgconfigDepends != []) ([pkgconfig] ++ pkgconfigDepends) ++
    optionals doCheck testDepends ++
    optionals (!hasActiveLibrary) buildDepends;
  propagatedNativeBuildInputs = optionals hasActiveLibrary buildDepends;

  # GHC needs the locale configured during the Haddock phase.
  LANG = "en_US.UTF-8";
  LOCALE_ARCHIVE = optionalString stdenv.isLinux "${glibcLocales}/lib/locale/locale-archive";

  configurePhase = ''
    runHook preConfigure

    echo "Building with ${ghc}."
    export PATH="${ghc}/bin:$PATH"
    ${optionalString (hasActiveLibrary && hyperlinkSource) "export PATH=${hscolour}/bin:$PATH"}

    configureFlags="--verbose --prefix=$out --libdir=\$prefix/lib/\$compiler --libsubdir=\$pkgid $configureFlags"
    configureFlags+=' ${concatStringsSep " " defaultConfigureFlags}'
    ${optionalString (enableSharedExecutables && stdenv.isLinux) ''
      configureFlags+=" --ghc-option=-optl=-Wl,-rpath=$out/lib/${ghc.name}/${pname}-${version}"
    ''}
    ${optionalString (enableSharedExecutables && stdenv.isDarwin) ''
      configureFlags+=" --ghc-option=-optl=-Wl,-headerpad_max_install_names"
    ''}
    ${optionalString (versionOlder "7.8" ghc.version && !isLibrary) ''
      configureFlags+=" --ghc-option=-j$NIX_BUILD_CORES"
      setupCompileFlags="-j$NIX_BUILD_CORES"
    ''}

    packageConfDir="$TMP/package.conf.d"
    mkdir -p $packageConfDir

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
      for d in lib{,64}; do
        if [ -d "$p/$d" ]; then
          configureFlags+=" --extra-lib-dirs=$p/$d"
        fi
      done
    done
    ghc-pkg --package-db="$packageConfDir" recache
    configureFlags+=" --package-db=$packageConfDir"

    ${optionalString (editedCabalFile != null) ''
      echo "Replacing Cabal file with edited version ${newCabalFile}."
      cp ${newCabalFile} ${pname}.cabal
    ''}

    ${optionalString jailbreak ''
      echo "Running jailbreak-cabal to lift version restrictions on build inputs."
      ${jailbreak-cabal}/bin/jailbreak-cabal ${pname}.cabal
    ''}

    for i in Setup.hs Setup.lhs ${defaultSetupHs}; do
      test -f $i && break
    done
    ghc ${optionalString (! coreSetup) "-package-db=$packageConfDir "}$setupCompileFlags --make -o Setup -odir $TMPDIR -hidir $TMPDIR $i

    echo configureFlags: $configureFlags
    unset GHC_PACKAGE_PATH      # Cabal complains if this variable is set during configure.
    ./Setup configure $configureFlags 2>&1 | ${coreutils}/bin/tee "$NIX_BUILD_TOP/cabal-configure.log"
    if ${gnugrep}/bin/egrep -q '^Warning:.*depends on multiple versions' "$NIX_BUILD_TOP/cabal-configure.log"; then
      echo >&2 "*** abort because of serious configure-time warning from Cabal"
      exit 1
    fi

    export GHC_PACKAGE_PATH="$packageConfDir:"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ./Setup build
    ${optionalString (!noHaddock && hasActiveLibrary) ''
      ./Setup haddock --html \
        ${optionalString doHoogle "--hoogle"} \
        ${optionalString (hasActiveLibrary && hyperlinkSource) "--hyperlink-source"}
    ''}
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    ./Setup test ${testTarget}
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    ${if !hasActiveLibrary then "./Setup install" else ''
      ./Setup copy
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

  passthru = passthru // {

    inherit pname version;

    env = stdenv.mkDerivation {
      name = "interactive-${optionalString hasActiveLibrary "haskell-"}${pname}-${version}-environment";
      nativeBuildInputs = [ ghcEnv systemBuildInputs ];
      shellHook = ''
        export NIX_GHC="${ghcEnv}/bin/ghc"
        export NIX_GHCPKG="${ghcEnv}/bin/ghc"
        export NIX_GHC_DOCDIR="${ghcEnv}/share/doc/ghc/html"
        export NIX_GHC_LIBDIR="${ghcEnv}/lib/${ghcEnv.name}"
      '';
      buildCommand = ''
        echo >&2 ""
        echo >&2 "*** Haskell 'env' attributes are intended for interactive nix-shell sessions, not for building! ***"
        echo >&2 ""
        exit 1
      '';
    };

  };

  meta = { inherit homepage license platforms hydraPlatforms; }
         // optionalAttrs broken               { inherit broken; }
         // optionalAttrs (description != "")  { inherit description; }
         // optionalAttrs (maintainers != [])  { inherit maintainers; }
         ;

}
// optionalAttrs (configureFlags != []) { inherit configureFlags; }
// optionalAttrs (patches != [])        { inherit patches; }
// optionalAttrs (patchPhase != "")     { inherit patchPhase; }
// optionalAttrs (prePatch != "")       { inherit prePatch; }
// optionalAttrs (postPatch != "")      { inherit postPatch; }
// optionalAttrs (preConfigure != "")   { inherit preConfigure; }
// optionalAttrs (postConfigure != "")  { inherit postConfigure; }
// optionalAttrs (preBuild != "")       { inherit preBuild; }
// optionalAttrs (postBuild != "")      { inherit postBuild; }
// optionalAttrs (preInstall != "")     { inherit preInstall; }
// optionalAttrs (postInstall != "")    { inherit postInstall; }
// optionalAttrs (checkPhase != "")     { inherit checkPhase; }
// optionalAttrs (preCheck != "")       { inherit preCheck; }
// optionalAttrs (postCheck != "")      { inherit postCheck; }
// optionalAttrs (preFixup != "")       { inherit preFixup; }
// optionalAttrs (postFixup != "")      { inherit postFixup; }
)
