#
# A copy of the functionality in pkgs/development/haskell-modules/lib.nix
# except that the functions take the "drv" or "pkg" arguments last, to make
# applying several of these functions less awkward.
#

{ unflipped }:

rec {
  /* This function takes a file like `hackage-packages.nix` and constructs
     a full package set out of that.
  */
  makePackageSet = unflipped.makePackageSet;

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

         > x = haskell.lib.overrideCabal haskellPackages.aeson (old: { homepage = old.homepage + "#readme"; })
         > x.meta.homepage
         "https://github.com/bos/aeson#readme"
  */
  overrideCabal = f: drv: unflipped.overrideCabal drv f;

  # : Map Name (Either Path VersionNumber) -> HaskellPackageOverrideSet
  # Given a set whose values are either paths or version strings, produces
  # a package override set (i.e. (self: super: { etc. })) that sets
  # the packages named in the input set to the corresponding versions
  packageSourceOverrides = unflipped.packageSourceOverrides;

  /* doCoverage modifies a haskell package to enable the generation
     and installation of a coverage report.

     See https://wiki.haskell.org/Haskell_program_coverage
  */
  doCoverage = unflipped.doCoverage;

  /* dontCoverage modifies a haskell package to disable the generation
     and installation of a coverage report.
  */
  dontCoverage = unflipped.dontCoverage;

  /* doHaddock modifies a haskell package to enable the generation and
     installation of API documentation from code comments using the
     haddock tool.
  */
  doHaddock = unflipped.doHaddock;

  /* dontHaddock modifies a haskell package to disable the generation and
     installation of API documentation from code comments using the
     haddock tool.
  */
  dontHaddock = unflipped.dontHaddock;

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
  doJailbreak = unflipped.doJailbreak;

  /* dontJailbreak restores the use of the version bounds the check
     the use of dependencies in the package description.
  */
  dontJailbreak = unflipped.dontJailbreak;

  /* doCheck enables dependency checking, compilation and execution
     of test suites listed in the package description file.
  */
  doCheck = unflipped.doCheck;
  /* dontCheck disables dependency checking, compilation and execution
     of test suites listed in the package description file.
  */
  dontCheck = unflipped.dontCheck;

  /* doBenchmark enables dependency checking, compilation and execution
     for benchmarks listed in the package description file.
  */
  doBenchmark = unflipped.doBenchmark;
  /* dontBenchmark disables dependency checking, compilation and execution
     for benchmarks listed in the package description file.
  */
  dontBenchmark = unflipped.dontBenchmark;

  /* doDistribute enables the distribution of binaries for the package
     via hydra.
  */
  doDistribute = unflipped.doDistribute;
  /* dontDistribute disables the distribution of binaries for the package
     via hydra.
  */
  dontDistribute = unflipped.dontDistribute;

  /* appendConfigureFlag adds a single argument that will be passed to the
     cabal configure command, after the arguments that have been defined
     in the initial declaration or previous overrides.

     Example:

         > haskell.lib.appendConfigureFlag haskellPackages.servant "--profiling-detail=all-functions"
  */
  appendConfigureFlag = x: drv: unflipped.appendConfigureFlag drv x;
  appendConfigureFlags = xs: drv: unflipped.appendConfigureFlags drv xs;

  appendBuildFlag = x: drv: unflipped.appendBuildFlag drv x;
  appendBuildFlags = xs: drv: unflipped.appendBuildFlags drv xs;

  /* removeConfigureFlag x drv is a Haskell package like drv, but with
     all cabal configure arguments that are equal to x removed.

         > haskell.lib.removeConfigureFlag haskellPackages.servant "--verbose"
  */
  removeConfigureFlag = x: drv: unflipped.removeConfigureFlag drv x;

  addBuildTool = x: drv: unflipped.addBuildTool drv x;
  addBuildTools = xs: drv: unflipped.addBuildTools drv xs;

  addExtraLibrary = x: drv: unflipped.addExtraLibrary drv x;
  addExtraLibraries = xs: drv: unflipped.addExtraLibraries drv xs;

  addBuildDepend = x: drv: unflipped.addBuildDepend drv x;
  addBuildDepends = xs: drv: unflipped.addBuildDepends drv xs;

  addPkgconfigDepend = x: drv: unflipped.addPkgconfigDepend drv x;
  addPkgconfigDepends = xs: drv: unflipped.addPkgconfigDepends drv xs;

  addSetupDepend = x: drv: unflipped.addSetupDepend drv x;
  addSetupDepends = xs: drv: unflipped.addSetupDepends drv xs;

  enableCabalFlag = x: drv: unflipped.enableCabalFlag drv x;
  disableCabalFlag = x: drv: unflipped.disableCabalFlag drv x;

  markBroken = unflipped.markBroken;
  unmarkBroken = unflipped.unmarkBroken;
  markBrokenVersion = unflipped.markBrokenVersion;
  markUnbroken = unflipped.markUnbroken;

  enableLibraryProfiling = unflipped.enableLibraryProfiling;
  disableLibraryProfiling = unflipped.disableLibraryProfiling;

  enableExecutableProfiling = unflipped.enableExecutableProfiling;
  disableExecutableProfiling = unflipped.disableExecutableProfiling;

  enableSharedExecutables = unflipped.enableSharedExecutables;
  disableSharedExecutables = unflipped.disableSharedExecutables;

  enableSharedLibraries = unflipped.enableSharedLibraries;
  disableSharedLibraries = unflipped.disableSharedLibraries;

  enableDeadCodeElimination = unflipped.enableDeadCodeElimination;
  disableDeadCodeElimination = unflipped.disableDeadCodeElimination;

  enableStaticLibraries = unflipped.enableStaticLibraries;
  disableStaticLibraries = unflipped.disableStaticLibraries;

  enableSeparateBinOutput = unflipped.enableSeparateBinOutput;

  appendPatch = x: drv: unflipped.appendPatch drv x;
  appendPatches = xs: drv: unflipped.appendPatches drv xs;

  doHyperlinkSource = unflipped.doHyperlinkSource;
  dontHyperlinkSource = unflipped.dontHyperlinkSource;

  disableHardening = flags: drv: unflipped.disableHardening drv flags;

  # Let Nix strip the binary files.
  # This removes debugging symbols.
  doStrip = unflipped.doStrip;

  # Stop Nix from stripping the binary files.
  # This keeps debugging symbols.
  dontStrip = unflipped.dontStrip;

  # Useful for debugging segfaults with gdb.
  # This includes dontStrip.
  enableDWARFDebugging = unflipped.enableDWARFDebugging;

  /* Create a source distribution tarball like those found on hackage,
     instead of building the package.
  */
  sdistTarball = unflipped.sdistTarball;

  /* Use the gold linker. It is a linker for ELF that is designed
     "to run as fast as possible on modern systems"
  */
  linkWithGold = unflipped.linkWithGold;

  /* link executables statically against haskell libs to reduce
     closure size
  */
  justStaticExecutables = unflipped.justStaticExecutables;

  /* Build a source distribution tarball instead of using the source files
     directly. The effect is that the package is built as if it were published
     on hackage. This can be used as a test for the source distribution,
     assuming the build fails when packaging mistakes are in the cabal file.
  */
  buildFromSdist = unflipped.buildFromSdist;

  /* Build the package in a strict way to uncover potential problems.
     This includes buildFromSdist and failOnAllWarnings.
  */
  buildStrictly = unflipped.buildStrictly;

  # Disable core optimizations, significantly speeds up build time
  disableOptimization = unflipped.disableOptimization;

  /* Turn on most of the compiler warnings and fail the build if any
     of them occur.
  */
  failOnAllWarnings = unflipped.failOnAllWarnings;

  /* Add a post-build check to verify that dependencies declared in
     the cabal file are actually used.

     The first attrset argument can be used to configure the strictness
     of this check and a list of ignored package names that would otherwise
     cause false alarms.
  */
  checkUnusedPackages = unflipped.checkUnusedPackages;

  buildStackProject = unflipped.buildStackProject;

  /* Add a dummy command to trigger a build despite an equivalent
     earlier build that is present in the store or cache.
  */
  triggerRebuild = i: drv: unflipped.triggerRebuild drv i;

  /* Override the sources for the package and optionaly the version.
     This also takes of removing editedCabalFile.
  */
  overrideSrc = unflipped.overrideSrc;

  # Get all of the build inputs of a haskell package, divided by category.
  getBuildInputs = unflipped.getBuildInputs;

  # Extract the haskell build inputs of a haskell package.
  # This is useful to build environments for developing on that
  # package.
  getHaskellBuildInputs = unflipped.getHaskellBuildInputs;

  # Under normal evaluation, simply return the original package. Under
  # nix-shell evaluation, return a nix-shell optimized environment.
  shellAware = unflipped.shellAware;

  ghcInfo = unflipped.ghcInfo;

  ### mkDerivation helpers
  # These allow external users of a haskell package to extract
  # information about how it is built in the same way that the
  # generic haskell builder does, by reusing the same functions.
  # Each function here has the same interface as mkDerivation and thus
  # can be called for a given package simply by overriding the
  # mkDerivation argument it used. See getHaskellBuildInputs above for
  # an example of this.

  # Some information about which phases should be run.
  controlPhases = unflipped.controlPhases;

  # Utility to convert a directory full of `cabal2nix`-generated files into a
  # package override set
  #
  # packagesFromDirectory : { directory : Directory, ... } -> HaskellPackageOverrideSet
  packagesFromDirectory = unflipped.packagesFromDirectory;

  addOptparseApplicativeCompletionScripts =
    unflipped.addOptparseApplicativeCompletionScripts;

  /* Modify a Haskell package to add shell completion scripts for the
     given executable produced by it. These completion scripts will be
     picked up automatically if the resulting derivation is installed,
     e.g. by `nix-env -i`.

     Invocation:
       generateOptparseApplicativeCompletions command pkg

       command: name of an executable
           pkg: Haskell package that builds the executables
  */
  generateOptparseApplicativeCompletion =
    unflipped.generateOptparseApplicativeCompletion;

  /* Modify a Haskell package to add shell completion scripts for the
     given executables produced by it. These completion scripts will be
     picked up automatically if the resulting derivation is installed,
     e.g. by `nix-env -i`.

     Invocation:
       generateOptparseApplicativeCompletions commands pkg

      commands: name of an executable
           pkg: Haskell package that builds the executables
  */
  generateOptparseApplicativeCompletions =
    unflipped.generateOptparseApplicativeCompletions;

  # Don't fail at configure time if there are multiple versions of the
  # same package in the (recursive) dependencies of the package being
  # built. Will delay failures, if any, to compile time.
  allowInconsistentDependencies = unflipped.allowInconsistentDependencies;
}
