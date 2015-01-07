{ stdenv, fetchurl, ghc, pkgconfig, glibcLocales, coreutils, gnugrep, gnused
, jailbreak-cabal, hscolour
}:

{ pname, version, sha256 ? null
, src ? fetchurl { url = "mirror://hackage/${pname}-${version}.tar.gz"; inherit sha256; }
, buildDepends ? []
, extraLibraries ? []
, configureFlags ? []
, configureFlagsArray ? []
, pkgconfigDepends ? []
, noHaddock ? false
, buildTools ? []
, patches ? [], patchPhase ? "", prePatch ? "", postPatch ? ""
, preConfigure ? "", postConfigure ? ""
, preBuild ? "", postBuild ? ""
, installPhase ? "", preInstall ? "", postInstall ? ""
, checkPhase ? "", preCheck ? "", postCheck ? ""
, preFixup ? "", postFixup ? ""
, isExecutable ? false, isLibrary ? !isExecutable
, propagatedUserEnvPkgs ? []
, testDepends ? []
, doCheck ? stdenv.lib.versionOlder "7.4" ghc.version, testTarget ? ""
, jailbreak ? false
, hyperlinkSource ? true
, enableLibraryProfiling ? false
, enableSharedExecutables ? stdenv.lib.versionOlder "7.7" ghc.version
, enableSharedLibraries ? stdenv.lib.versionOlder "7.7" ghc.version
, enableSplitObjs ? !stdenv.isDarwin # http://hackage.haskell.org/trac/ghc/ticket/4013
, enableStaticLibraries ? true
, homepage ? "http://hackage.haskell.org/package/${pname}"
, description ? "no description available"
, license
, editedCabalFile ? null
, platforms ? ghc.meta.platforms
, hydraPlatforms ? ghc.meta.hydraPlatforms or ghc.meta.platforms
, broken ? false
, maintainers ? []
, passthru ? {}
}:

assert pkgconfigDepends != [] -> pkgconfig != null;

let

  inherit (stdenv.lib) optional optionals optionalString versionOlder
                       concatStringsSep enableFeature;

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

in
stdenv.mkDerivation {
  name = "${optionalString hasActiveLibrary "haskell-"}${pname}-${version}";

  inherit src;

  nativeBuildInputs = extraLibraries ++ buildTools ++
    optionals (pkgconfigDepends != []) ([pkgconfig] ++ pkgconfigDepends) ++
    optionals doCheck testDepends;
  propagatedNativeBuildInputs = buildDepends;

  inherit propagatedUserEnvPkgs;
  inherit patches patchPhase prePatch postPatch;
  inherit preConfigure postConfigure configureFlags configureFlagsArray;
  inherit preBuild postBuild;
  inherit preInstall postInstall;
  inherit doCheck preCheck postCheck;
  inherit preFixup postFixup;

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

    local confDir=$out/nix-support/ghc-${ghc.version}-package.conf.d
    mkdir -p $confDir
    for p in $propagatedNativeBuildInputs $nativeBuildInputs; do
      if [ -d "$p/nix-support/ghc-${ghc.version}-package.conf.d" ]; then
        cp -f "$p/nix-support/ghc-${ghc.version}-package.conf.d/"*.conf $confDir/
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
    ghc-pkg --package-db=$confDir recache
    configureFlags+=" --package-db=$confDir"

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
    ghc -package-db=$confDir $setupCompileFlags --make -o Setup -odir $TMPDIR -hidir $TMPDIR $i

    echo configureFlags: $configureFlags
    unset GHC_PACKAGE_PATH      # Cabal complains about this variable if it's set.
    ./Setup configure $configureFlags 2>&1 | ${coreutils}/bin/tee "$NIX_BUILD_TOP/cabal-configure.log"
    if ${gnugrep}/bin/egrep -q '^Warning:.*depends on multiple versions' "$NIX_BUILD_TOP/cabal-configure.log"; then
      echo >&2 "*** abort because of serious configure-time warning from Cabal"
      exit 1
    fi

    export GHC_PACKAGE_PATH="$confDir:"

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ./Setup build
    ${optionalString (!noHaddock && hasActiveLibrary) ''
      ./Setup haddock --html --hoogle ${optionalString (hasActiveLibrary && hyperlinkSource) "--hyperlink-source"}
    ''}
    runHook postBuild
  '';

  checkPhase = if installPhase != "" then installPhase else ''
    runHook preCheck
    ./Setup test ${testTarget}
    runHook postCheck
  '';

  installPhase = if installPhase != "" then installPhase else ''
    runHook preInstall

    ${if !hasActiveLibrary then "./Setup install" else ''
      ./Setup copy
      local confDir=$out/nix-support/ghc-${ghc.version}-package.conf.d
      local pkgConf=$confDir/${pname}-${version}.conf
      mkdir -p $confDir
      ./Setup register --gen-pkg-config=$pkgConf
      local pkgId=$( ${gnused}/bin/sed -n -e 's|^id: ||p' $pkgConf )
      mv $pkgConf $confDir/$pkgId.conf
      ghc-pkg --package-db=$confDir recache
    ''}

    ${optionalString (enableSharedExecutables && isExecutable && stdenv.isDarwin) ''
      for exe in "$out/bin/"* ; do
        install_name_tool -add_rpath "$out/lib/ghc-${ghc.version}/${pname}-${version}" "$exe"
      done
    ''}

    runHook postInstall
  '';

  passthru = passthru // { inherit pname version; };

  meta = {
    inherit homepage license description platforms hydraPlatforms maintainers broken;
  };
}
