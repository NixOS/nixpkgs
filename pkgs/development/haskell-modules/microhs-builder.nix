{
  buildHaskellPackages,
  buildPackages,
  fetchurl,
  ghc,
  jailbreak-cabal,
  lib,
  MicroCabal,
  cpphs,
  ghc-compat,
  pkg-config,
  runCommandCC,
  stdenv,
  wrapMhs,
}:

let
  # make-package-set always names the compiler ghc
  compiler = ghc;

  isCross = stdenv.buildPlatform != stdenv.hostPlatform;

in
{
  pname,
  version,
  revision ? null,
  sha256 ? null,
  src ? fetchurl {
    url = "mirror://hackage/${pname}-${version}.tar.gz";
    inherit sha256;
  },
  # Extra environment variables to set during the build.
  # See: `../../../doc/languages-frameworks/haskell.section.md`
  env ? { },
  buildDepends ? [ ],
  setupHaskellDepends ? [ ],
  libraryHaskellDepends ? [ ],
  executableHaskellDepends ? [ ],
  buildTools ? [ ],
  libraryToolDepends ? [ ],
  executableToolDepends ? [ ],
  testToolDepends ? [ ],
  benchmarkToolDepends ? [ ],
  configureFlags ? [ ],
  description ? null,
  doCheck ? !isCross,
  doBenchmark ? false,
  editedCabalFile ? null,
  extraLibraries ? [ ],
  librarySystemDepends ? [ ],
  executableSystemDepends ? [ ],
  # On macOS, statically linking against system frameworks is not supported;
  # see https://developer.apple.com/library/content/qa/qa1118/_index.html
  # They must be propagated to the environment of any executable linking with the library
  libraryFrameworkDepends ? [ ],
  executableFrameworkDepends ? [ ],
  homepage ? "https://hackage.haskell.org/package/${pname}",
  platforms ? with lib.platforms; all, # GHC can cross-compile
  badPlatforms ? lib.platforms.none,
  hydraPlatforms ? null,
  isExecutable ? false,
  isLibrary ? !isExecutable,
  jailbreak ? false,
  license,
  maintainers ? null,
  teams ? null,
  changelog ? null,
  mainProgram ? null,
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
  ...
}@args:

assert editedCabalFile != null -> revision != null;

let
  allPkgconfigDepends =
    pkg-configDepends
    ++ libraryPkgconfigDepends
    ++ executablePkgconfigDepends
    ++ lib.optionals doCheck testPkgconfigDepends
    ++ lib.optionals doBenchmark benchmarkPkgconfigDepends;

  # MicroCabal adds a dependency on ghc-compat unless the package name is one of the following
  isCorePkg = pname == "base" || pname == "ghc-compat" || pname == "MicroHs" || pname == "MicroCabal";
  buildDepends' = buildDepends ++ lib.optional (!isCorePkg) ghc-compat;

  depsBuildBuild = lib.optionals (!stdenv.hasCC) [ buildPackages.stdenv.cc ];
  collectedToolDepends =
    buildTools
    ++ libraryToolDepends
    ++ executableToolDepends
    ++ lib.optionals doCheck testToolDepends
    ++ lib.optionals doBenchmark benchmarkToolDepends;
  nativeBuildInputs = [
    MicroCabal
    cpphs
    compilerWithPkgs
    buildPackages.removeReferencesTo
  ];
  propagatedBuildInputs =
    buildDepends' ++ libraryHaskellDepends ++ executableHaskellDepends ++ libraryFrameworkDepends;
  otherBuildInputsHaskell =
    lib.optionals doCheck (testDepends ++ testHaskellDepends)
    ++ lib.optionals doBenchmark (benchmarkDepends ++ benchmarkHaskellDepends);
  otherBuildInputsSystem =
    extraLibraries
    ++ librarySystemDepends
    ++ executableSystemDepends
    ++ executableFrameworkDepends
    ++ allPkgconfigDepends
    ++ lib.optionals doCheck (testSystemDepends ++ testFrameworkDepends)
    ++ lib.optionals doBenchmark (benchmarkSystemDepends ++ benchmarkFrameworkDepends);
  otherBuildInputs = otherBuildInputsHaskell ++ otherBuildInputsSystem;

  newCabalFileUrl = "mirror://hackage/${pname}-${version}/revision/${revision}.cabal";
  newCabalFile = fetchurl {
    url = newCabalFileUrl;
    sha256 = editedCabalFile;
    name = "${pname}-${version}-r${revision}.cabal";
  };

  hsLibBuildInputs = lib.filter (p: p ? isHaskellLibrary && p.isHaskellLibrary) propagatedBuildInputs;
  hsLibClosedBuildInputs = lib.closePropagation hsLibBuildInputs;
  compilerWithPkgs = wrapMhs {
    microhs = compiler;
    packages = hsLibClosedBuildInputs;
  };

  compilerCommand' = "mhs";
  compilerCommand = "${compiler.targetPrefix}${compilerCommand'}";

  compilerLibdir = "lib/mcabal/${compiler.haskellCompilerName}";

  env' = {
    CABALDIR = "${placeholder "out"}/lib/mcabal";
  }
  // env;

in
stdenv.mkDerivation {
  inherit pname version;

  pos = builtins.unsafeGetAttrPos "pname" args;

  prePhases = [ "setupCompilerEnvironmentPhase" ];
  preConfigurePhases = [ "compileBuildDriverPhase" ];
  preInstallPhases = [ "haddockPhase" ];

  inherit src patches;

  inherit depsBuildBuild nativeBuildInputs;
  buildInputs = lib.optionals (!isLibrary) propagatedBuildInputs;
  propagatedBuildInputs = lib.optionals isLibrary propagatedBuildInputs;

  env = env';

  prePatch =
    lib.optionalString (editedCabalFile != null) ''
      echo "Replace Cabal file with edited version from ${newCabalFileUrl}."
      cp ${newCabalFile} ${pname}.cabal
    ''
    + prePatch;

  postPatch =
    lib.optionalString jailbreak ''
      echo "Run jailbreak-cabal to lift version restrictions on build inputs."
      ${jailbreak-cabal}/bin/jailbreak-cabal ${pname}.cabal
    ''
    + postPatch;

  setupCompilerEnvironmentPhase = ''
    runHook preSetupCompilerEnvironment

    echo "Building with ${compilerWithPkgs}"
    mkdir -p "$CABALDIR/${compiler.haskellCompilerName}/packages"
    ${lib.concatMapStrings (
      p:
      let
        name = "${p.pname}-${p.version}";
      in
      ''
        printf 'Exposing dependency ${name}\n'
        ln -s ${p}/${compilerLibdir}/packages/${name}-${p.version}.pkg $CABALDIR/${compiler.haskellCompilerName}/packages/${name}.pkg
      ''
    ) hsLibClosedBuildInputs}

    runHook postSetupCompilerEnvironment
  '';

  compileBuildDriverPhase = ''
    runHook preCompileBuildDriver

    runHook postCompileBuildDriver
  '';

  buildPhase = ''
    runHook preBuild

    echo "Skipping buildPhase because MicroCabal always builds on install"

    runHook postBuild
  '';

  inherit doCheck;

  checkPhase = ''
    runHook preCheck

    echo "Skipping checkPhase because MicroCabal doesn't support test suites"

    runHook postCheck
  '';

  haddockPhase = ''
    runHook preHaddock

    echo "Skipping haddockPhase because MicroCabal doesn't support Haddock"

    runHook postHaddock
  '';

  installPhase = ''
    runHook preInstall

    mcabal -v ${lib.concatStringsSep " " configureFlags} install
    mkdir -p $out/bin
    find "$CABALDIR/bin" -type f -exec ln -s '{}' "$out/bin/" \; || true
    find "$CABALDIR/${compiler.haskellCompilerName}/packages" -type l -delete

    runHook postInstall
  '';

  inherit
    preCompileBuildDriver
    postCompileBuildDriver
    preUnpack
    postUnpack
    preConfigure
    postConfigure
    preBuild
    postBuild
    preHaddock
    postHaddock
    preInstall
    postInstall
    preCheck
    postCheck
    preFixup
    postFixup
    ;

  passthru = passthru // rec {
    inherit pname version;

    compiler = ghc;

    # All this information is intended just for `shellFor`.  It should be
    # considered unstable and indeed we knew how to keep it private we would.
    getCabalDeps = {
      inherit
        buildDepends'
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
      isHaskellPartition = lib.partition (x: x ? isHaskellLibrary) (
        propagatedBuildInputs ++ otherBuildInputs ++ depsBuildBuild ++ nativeBuildInputs
      );
    };

    isHaskellLibrary = isLibrary;

    haddockDir = null;

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
        # Unsupported
        withHoogle ? false,
      }:
      let
        name = "microhs-shell-for-${pname}";

        compilerCommandCaps = lib.toUpper compilerCommand';
      in
      runCommandCC name {
        inherit shellHook;

        nativeBuildInputs = [
          compilerWithPkgs
        ]
        ++ lib.optional (allPkgconfigDepends != [ ]) pkg-config
        ++ collectedToolDepends;
        buildInputs = otherBuildInputsSystem;

        env = {
          "NIX_${compilerCommandCaps}" = "${compiler}/bin/${compilerCommand}";
          # TODO: is this still valid?
          "NIX_${compilerCommandCaps}_LIBDIR" = "${compiler}/${compilerLibdir}";
        }
        // lib.optionalAttrs (stdenv.buildPlatform.libc == "glibc") {
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
    inherit homepage license platforms;
  }
  // lib.optionalAttrs (args ? broken) { inherit broken; }
  // lib.optionalAttrs (args ? description) { inherit description; }
  // lib.optionalAttrs (args ? maintainers) { inherit maintainers; }
  // lib.optionalAttrs (args ? teams) { inherit teams; }
  // lib.optionalAttrs (args ? hydraPlatforms) { inherit hydraPlatforms; }
  // lib.optionalAttrs (args ? badPlatforms) { inherit badPlatforms; }
  // lib.optionalAttrs (args ? changelog) { inherit changelog; }
  // lib.optionalAttrs (args ? mainProgram) { inherit mainProgram; };
}
