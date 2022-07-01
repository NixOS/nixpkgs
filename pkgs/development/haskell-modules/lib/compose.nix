# TODO(@Ericson2314): Remove `pkgs` param, which is only used for
# `buildStackProject`, `justStaticExecutables` and `checkUnusedPackages`
{ pkgs, lib }:

rec {

  /* This function takes a file like `hackage-packages.nix` and constructs
     a full package set out of that.
   */
  makePackageSet = import ../make-package-set.nix;

  /* The function overrideCabal lets you alter the arguments to the
     mkDerivation function.

     Example:

     First, note how the aeson package is constructed in hackage-packages.nix:

         "aeson" = callPackage ({ mkDerivation, attoparsec, <snip>
                                }:
                                  mkDerivation {
                                    pname = "aeson";
                                    <snip>
                                    homepage = "https://github.com/bos/aeson";
                                  })

     The mkDerivation function of haskellPackages will take care of putting
     the homepage in the right place, in meta.

         > haskellPackages.aeson.meta.homepage
         "https://github.com/bos/aeson"

         > x = haskell.lib.compose.overrideCabal (old: { homepage = old.homepage + "#readme"; }) haskellPackages.aeson
         > x.meta.homepage
         "https://github.com/bos/aeson#readme"

   */
  overrideCabal = f: drv: (drv.override (args: args // {
    mkDerivation = drv: (args.mkDerivation drv).override f;
  })) // {
    overrideScope = scope: overrideCabal f (drv.overrideScope scope);
  };

  # : Map Name (Either Path VersionNumber) -> HaskellPackageOverrideSet
  # Given a set whose values are either paths or version strings, produces
  # a package override set (i.e. (self: super: { etc. })) that sets
  # the packages named in the input set to the corresponding versions
  packageSourceOverrides =
    overrides: self: super: pkgs.lib.mapAttrs (name: src:
      let isPath = x: builtins.substring 0 1 (toString x) == "/";
          generateExprs = if isPath src
                             then self.callCabal2nix
                             else self.callHackage;
      in generateExprs name src {}) overrides;

  /* doCoverage modifies a haskell package to enable the generation
     and installation of a coverage report.

     See https://wiki.haskell.org/Haskell_program_coverage
   */
  doCoverage = overrideCabal (drv: { doCoverage = true; });

  /* dontCoverage modifies a haskell package to disable the generation
     and installation of a coverage report.
   */
  dontCoverage = overrideCabal (drv: { doCoverage = false; });

  /* doHaddock modifies a haskell package to enable the generation and
     installation of API documentation from code comments using the
     haddock tool.
   */
  doHaddock = overrideCabal (drv: { doHaddock = true; });

  /* dontHaddock modifies a haskell package to disable the generation and
     installation of API documentation from code comments using the
     haddock tool.
   */
  dontHaddock = overrideCabal (drv: { doHaddock = false; });

  /* doJailbreak enables the removal of version bounds from the cabal
     file. You may want to avoid this function.

     This is useful when a package reports that it can not be built
     due to version mismatches. In some cases, removing the version
     bounds entirely is an easy way to make a package build, but at
     the risk of breaking software in non-obvious ways now or in the
     future.

     Instead of jailbreaking, you can patch the cabal file.

     Note that jailbreaking at this time, doesn't lift bounds on
     conditional branches.
     https://github.com/peti/jailbreak-cabal/issues/7 has further details.

   */
  doJailbreak = overrideCabal (drv: { jailbreak = true; });

  /* dontJailbreak restores the use of the version bounds the check
     the use of dependencies in the package description.
   */
  dontJailbreak = overrideCabal (drv: { jailbreak = false; });

  /* doCheck enables dependency checking, compilation and execution
     of test suites listed in the package description file.
   */
  doCheck = overrideCabal (drv: { doCheck = true; });
  /* dontCheck disables dependency checking, compilation and execution
     of test suites listed in the package description file.
   */
  dontCheck = overrideCabal (drv: { doCheck = false; });

  /* doBenchmark enables dependency checking, compilation and execution
     for benchmarks listed in the package description file.
   */
  doBenchmark = overrideCabal (drv: { doBenchmark = true; });
  /* dontBenchmark disables dependency checking, compilation and execution
     for benchmarks listed in the package description file.
   */
  dontBenchmark = overrideCabal (drv: { doBenchmark = false; });

  /* doDistribute enables the distribution of binaries for the package
     via hydra.
   */
  doDistribute = overrideCabal (drv: {
    # lib.platforms.all is the default value for platforms (since GHC can cross-compile)
    hydraPlatforms = lib.subtractLists (drv.badPlatforms or [])
      (drv.platforms or lib.platforms.all);
  });
  /* dontDistribute disables the distribution of binaries for the package
     via hydra.
   */
  dontDistribute = overrideCabal (drv: { hydraPlatforms = []; });

  /* appendConfigureFlag adds a single argument that will be passed to the
     cabal configure command, after the arguments that have been defined
     in the initial declaration or previous overrides.

     Example:

         > haskell.lib.compose.appendConfigureFlag "--profiling-detail=all-functions" haskellPackages.servant
   */
  appendConfigureFlag = x: appendConfigureFlags [x];
  appendConfigureFlags = xs: overrideCabal (drv: { configureFlags = (drv.configureFlags or []) ++ xs; });

  appendBuildFlag = x: overrideCabal (drv: { buildFlags = (drv.buildFlags or []) ++ [x]; });
  appendBuildFlags = xs: overrideCabal (drv: { buildFlags = (drv.buildFlags or []) ++ xs; });

  /* removeConfigureFlag drv x is a Haskell package like drv, but with
     all cabal configure arguments that are equal to x removed.

         > haskell.lib.compose.removeConfigureFlag "--verbose" haskellPackages.servant
   */
  removeConfigureFlag = x: overrideCabal (drv: { configureFlags = lib.remove x (drv.configureFlags or []); });

  addBuildTool = x: addBuildTools [x];
  addBuildTools = xs: overrideCabal (drv: { buildTools = (drv.buildTools or []) ++ xs; });

  addExtraLibrary = x: addExtraLibraries [x];
  addExtraLibraries = xs: overrideCabal (drv: { extraLibraries = (drv.extraLibraries or []) ++ xs; });

  addBuildDepend = x: addBuildDepends [x];
  addBuildDepends = xs: overrideCabal (drv: { buildDepends = (drv.buildDepends or []) ++ xs; });

  addTestToolDepend = x: addTestToolDepends [x];
  addTestToolDepends = xs: overrideCabal (drv: { testToolDepends = (drv.testToolDepends or []) ++ xs; });

  addPkgconfigDepend = x: addPkgconfigDepends [x];
  addPkgconfigDepends = xs: overrideCabal (drv: { pkg-configDepends = (drv.pkg-configDepends or []) ++ xs; });

  addSetupDepend = x: addSetupDepends [x];
  addSetupDepends = xs: overrideCabal (drv: { setupHaskellDepends = (drv.setupHaskellDepends or []) ++ xs; });

  enableCabalFlag = x: drv: appendConfigureFlag "-f${x}" (removeConfigureFlag "-f-${x}" drv);
  disableCabalFlag = x: drv: appendConfigureFlag "-f-${x}" (removeConfigureFlag "-f${x}" drv);

  markBroken = overrideCabal (drv: { broken = true; hydraPlatforms = []; });
  unmarkBroken = overrideCabal (drv: { broken = false; });
  markBrokenVersion = version: drv: assert drv.version == version; markBroken drv;
  markUnbroken = overrideCabal (drv: { broken = false; });

  enableLibraryProfiling = overrideCabal (drv: { enableLibraryProfiling = true; });
  disableLibraryProfiling = overrideCabal (drv: { enableLibraryProfiling = false; });

  enableExecutableProfiling = overrideCabal (drv: { enableExecutableProfiling = true; });
  disableExecutableProfiling = overrideCabal (drv: { enableExecutableProfiling = false; });

  enableSharedExecutables = overrideCabal (drv: { enableSharedExecutables = true; });
  disableSharedExecutables = overrideCabal (drv: { enableSharedExecutables = false; });

  enableSharedLibraries = overrideCabal (drv: { enableSharedLibraries = true; });
  disableSharedLibraries = overrideCabal (drv: { enableSharedLibraries = false; });

  enableDeadCodeElimination = overrideCabal (drv: { enableDeadCodeElimination = true; });
  disableDeadCodeElimination = overrideCabal (drv: { enableDeadCodeElimination = false; });

  enableStaticLibraries = overrideCabal (drv: { enableStaticLibraries = true; });
  disableStaticLibraries = overrideCabal (drv: { enableStaticLibraries = false; });

  enableSeparateBinOutput = overrideCabal (drv: { enableSeparateBinOutput = true; });

  appendPatch = x: appendPatches [x];
  appendPatches = xs: overrideCabal (drv: { patches = (drv.patches or []) ++ xs; });

  /* Set a specific build target instead of compiling all targets in the package.
   * For example, imagine we have a .cabal file with a library, and 2 executables "dev" and "server".
   * We can build only "server" and not wait on the compilation of "dev" by using setBuildTarget as follows:
   *
   *   > setBuildTarget "server" (callCabal2nix "thePackageName" thePackageSrc {})
   *
   */
  setBuildTargets = xs: overrideCabal (drv: { buildTarget = lib.concatStringsSep " " xs; });
  setBuildTarget = x: setBuildTargets [x];

  doHyperlinkSource = overrideCabal (drv: { hyperlinkSource = true; });
  dontHyperlinkSource = overrideCabal (drv: { hyperlinkSource = false; });

  disableHardening = flags: overrideCabal (drv: { hardeningDisable = flags; });

  /* Let Nix strip the binary files.
   * This removes debugging symbols.
   */
  doStrip = overrideCabal (drv: { dontStrip = false; });

  /* Stop Nix from stripping the binary files.
   * This keeps debugging symbols.
   */
  dontStrip = overrideCabal (drv: { dontStrip = true; });

  /* Useful for debugging segfaults with gdb.
   * This includes dontStrip.
   */
  enableDWARFDebugging = drv:
   # -g: enables debugging symbols
   # --disable-*-stripping: tell GHC not to strip resulting binaries
   # dontStrip: see above
   appendConfigureFlag "--ghc-options=-g --disable-executable-stripping --disable-library-stripping" (dontStrip drv);

  /* Create a source distribution tarball like those found on hackage,
     instead of building the package.
   */
  sdistTarball = pkg: lib.overrideDerivation pkg (drv: {
    name = "${drv.pname}-source-${drv.version}";
    # Since we disable the haddock phase, we also need to override the
    # outputs since the separate doc output will not be produced.
    outputs = ["out"];
    buildPhase = "./Setup sdist";
    haddockPhase = ":";
    checkPhase = ":";
    installPhase = "install -D dist/${drv.pname}-*.tar.gz $out/${drv.pname}-${drv.version}.tar.gz";
    fixupPhase = ":";
  });

  /* Create a documentation tarball suitable for uploading to Hackage instead
     of building the package.
   */
  documentationTarball = pkg:
    pkgs.lib.overrideDerivation pkg (drv: {
      name = "${drv.name}-docs";
      # Like sdistTarball, disable the "doc" output here.
      outputs = [ "out" ];
      buildPhase = ''
        runHook preHaddock
        ./Setup haddock --for-hackage
        runHook postHaddock
      '';
      haddockPhase = ":";
      checkPhase = ":";
      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        tar --format=ustar \
          -czf "$out/${drv.name}-docs.tar.gz" \
          -C dist/doc/html "${drv.name}-docs"
        runHook postInstall
      '';
    });

  /* Use the gold linker. It is a linker for ELF that is designed
     "to run as fast as possible on modern systems"
   */
  linkWithGold = appendConfigureFlag
    "--ghc-option=-optl-fuse-ld=gold --ld-option=-fuse-ld=gold --with-ld=ld.gold";

  /* link executables statically against haskell libs to reduce
     closure size
   */
  justStaticExecutables = overrideCabal (drv: {
    enableSharedExecutables = false;
    enableLibraryProfiling = false;
    isLibrary = false;
    doHaddock = false;
    postFixup = drv.postFixup or "" + ''

      # Remove every directory which could have links to other store paths.
      rm -rf $out/lib $out/nix-support $out/share/doc
    '';
  });

  /* Build a source distribution tarball instead of using the source files
     directly. The effect is that the package is built as if it were published
     on hackage. This can be used as a test for the source distribution,
     assuming the build fails when packaging mistakes are in the cabal file.

     A faster implementation using `cabal-install` is available as
     `buildFromCabalSdist` in your Haskell package set.
   */
  buildFromSdist = pkg: overrideCabal (drv: {
    src = "${sdistTarball pkg}/${pkg.pname}-${pkg.version}.tar.gz";

    # Revising and jailbreaking the cabal file has been handled in sdistTarball
    revision = null;
    editedCabalFile = null;
    jailbreak = false;
  }) pkg;

  /* Build the package in a strict way to uncover potential problems.
     This includes buildFromSdist and failOnAllWarnings.
   */
  buildStrictly = pkg: buildFromSdist (failOnAllWarnings pkg);

  /* Disable core optimizations, significantly speeds up build time */
  disableOptimization = appendConfigureFlag "--disable-optimization";

  /* Turn on most of the compiler warnings and fail the build if any
     of them occur. */
  failOnAllWarnings = appendConfigureFlag "--ghc-option=-Wall --ghc-option=-Werror";

  /* Add a post-build check to verify that dependencies declared in
     the cabal file are actually used.

     The first attrset argument can be used to configure the strictness
     of this check and a list of ignored package names that would otherwise
     cause false alarms.
   */
  checkUnusedPackages =
    { ignoreEmptyImports ? false
    , ignoreMainModule   ? false
    , ignorePackages     ? []
    } : drv :
      overrideCabal (_drv: {
        postBuild = with lib;
          let args = concatStringsSep " " (
                       optional ignoreEmptyImports "--ignore-empty-imports" ++
                       optional ignoreMainModule   "--ignore-main-module" ++
                       map (pkg: "--ignore-package ${pkg}") ignorePackages
                     );
          in "${pkgs.haskellPackages.packunused}/bin/packunused" +
             optionalString (args != "") " ${args}";
      }) (appendConfigureFlag "--ghc-option=-ddump-minimal-imports" drv);

  buildStackProject = pkgs.callPackage ../generic-stack-builder.nix { };

  /* Add a dummy command to trigger a build despite an equivalent
     earlier build that is present in the store or cache.
   */
  triggerRebuild = i: overrideCabal (drv: { postUnpack = ": trigger rebuild ${toString i}"; });

  /* Override the sources for the package and optionaly the version.
     This also takes of removing editedCabalFile.
   */
  overrideSrc = { src, version ? null }: drv:
    overrideCabal (_: { inherit src; version = if version == null then drv.version else version; editedCabalFile = null; }) drv;

  # Get all of the build inputs of a haskell package, divided by category.
  getBuildInputs = p: p.getBuildInputs;

  # Extract the haskell build inputs of a haskell package.
  # This is useful to build environments for developing on that
  # package.
  getHaskellBuildInputs = p: (getBuildInputs p).haskellBuildInputs;

  # Under normal evaluation, simply return the original package. Under
  # nix-shell evaluation, return a nix-shell optimized environment.
  shellAware = p: if lib.inNixShell then p.env else p;

  ghcInfo = ghc:
    rec { isCross = (ghc.cross or null) != null;
          isGhcjs = ghc.isGhcjs or false;
          nativeGhc = if isCross || isGhcjs
                        then ghc.bootPkgs.ghc
                        else ghc;
        };

  ### mkDerivation helpers
  # These allow external users of a haskell package to extract
  # information about how it is built in the same way that the
  # generic haskell builder does, by reusing the same functions.
  # Each function here has the same interface as mkDerivation and thus
  # can be called for a given package simply by overriding the
  # mkDerivation argument it used. See getHaskellBuildInputs above for
  # an example of this.

  # Some information about which phases should be run.
  controlPhases = ghc: let inherit (ghcInfo ghc) isCross; in
                  { doCheck ? !isCross && (lib.versionOlder "7.4" ghc.version)
                  , doBenchmark ? false
                  , ...
                  }: { inherit doCheck doBenchmark; };

  # Utility to convert a directory full of `cabal2nix`-generated files into a
  # package override set
  #
  # packagesFromDirectory : { directory : Directory, ... } -> HaskellPackageOverrideSet
  packagesFromDirectory =
    { directory, ... }:

    self: super:
      let
        haskellPaths = builtins.attrNames (builtins.readDir directory);

        toKeyVal = file: {
          name  = builtins.replaceStrings [ ".nix" ] [ "" ] file;

          value = self.callPackage (directory + "/${file}") { };
        };

      in
        builtins.listToAttrs (map toKeyVal haskellPaths);

  addOptparseApplicativeCompletionScripts = exeName: pkg:
    builtins.trace "addOptparseApplicativeCompletionScripts is deprecated in favor of generateOptparseApplicativeCompletion. Please change ${pkg.name} to use the latter or its plural form."
    (generateOptparseApplicativeCompletion exeName pkg);

  /*
    Modify a Haskell package to add shell completion scripts for the
    given executable produced by it. These completion scripts will be
    picked up automatically if the resulting derivation is installed,
    e.g. by `nix-env -i`.

    Invocation:
      generateOptparseApplicativeCompletion command pkg


      command: name of an executable
          pkg: Haskell package that builds the executables
  */
  generateOptparseApplicativeCompletion = exeName: overrideCabal (drv: {
    postInstall = (drv.postInstall or "") + ''
      bashCompDir="''${!outputBin}/share/bash-completion/completions"
      zshCompDir="''${!outputBin}/share/zsh/vendor-completions"
      fishCompDir="''${!outputBin}/share/fish/vendor_completions.d"
      mkdir -p "$bashCompDir" "$zshCompDir" "$fishCompDir"
      "''${!outputBin}/bin/${exeName}" --bash-completion-script "''${!outputBin}/bin/${exeName}" >"$bashCompDir/${exeName}"
      "''${!outputBin}/bin/${exeName}" --zsh-completion-script "''${!outputBin}/bin/${exeName}" >"$zshCompDir/_${exeName}"
      "''${!outputBin}/bin/${exeName}" --fish-completion-script "''${!outputBin}/bin/${exeName}" >"$fishCompDir/${exeName}.fish"

      # Sanity check
      grep -F ${exeName} <$bashCompDir/${exeName} >/dev/null || {
        echo 'Could not find ${exeName} in completion script.'
        exit 1
      }
    '';
  });

  /*
    Modify a Haskell package to add shell completion scripts for the
    given executables produced by it. These completion scripts will be
    picked up automatically if the resulting derivation is installed,
    e.g. by `nix-env -i`.

    Invocation:
      generateOptparseApplicativeCompletions commands pkg


     commands: name of an executable
          pkg: Haskell package that builds the executables
  */
  generateOptparseApplicativeCompletions = commands: pkg:
    pkgs.lib.foldr generateOptparseApplicativeCompletion pkg commands;

  # Don't fail at configure time if there are multiple versions of the
  # same package in the (recursive) dependencies of the package being
  # built. Will delay failures, if any, to compile time.
  allowInconsistentDependencies = overrideCabal (drv: {
    allowInconsistentDependencies = true;
  });
}
