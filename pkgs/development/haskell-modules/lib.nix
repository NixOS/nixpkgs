# TODO(@Ericson2314): Remove `pkgs` param, which is only used for
# `buildStackProject`, `justStaticExecutables` and `checkUnusedPackages`
{ pkgs, lib }:

rec {
  makePackageSet = import ./make-package-set.nix;

  overrideCabal = drv: f: (drv.override (args: args // {
    mkDerivation = drv: (args.mkDerivation drv).override f;
  })) // {
    overrideScope = scope: overrideCabal (drv.overrideScope scope) f;
  };

  doCoverage = drv: overrideCabal drv (drv: { doCoverage = true; });
  dontCoverage = drv: overrideCabal drv (drv: { doCoverage = false; });

  doHaddock = drv: overrideCabal drv (drv: { doHaddock = true; });
  dontHaddock = drv: overrideCabal drv (drv: { doHaddock = false; });

  doJailbreak = drv: overrideCabal drv (drv: { jailbreak = true; });
  dontJailbreak = drv: overrideCabal drv (drv: { jailbreak = false; });

  doCheck = drv: overrideCabal drv (drv: { doCheck = true; });
  dontCheck = drv: overrideCabal drv (drv: { doCheck = false; });

  doBenchmark = drv: overrideCabal drv (drv: { doBenchmark = true; });
  dontBenchmark = drv: overrideCabal drv (drv: { doBenchmark = false; });

  doDistribute = drv: overrideCabal drv (drv: { hydraPlatforms = drv.platforms or ["i686-linux" "x86_64-linux" "x86_64-darwin"]; });
  dontDistribute = drv: overrideCabal drv (drv: { hydraPlatforms = []; });

  appendConfigureFlag = drv: x: overrideCabal drv (drv: { configureFlags = (drv.configureFlags or []) ++ [x]; });
  removeConfigureFlag = drv: x: overrideCabal drv (drv: { configureFlags = lib.remove x (drv.configureFlags or []); });

  addBuildTool = drv: x: addBuildTools drv [x];
  addBuildTools = drv: xs: overrideCabal drv (drv: { buildTools = (drv.buildTools or []) ++ xs; });

  addExtraLibrary = drv: x: addExtraLibraries drv [x];
  addExtraLibraries = drv: xs: overrideCabal drv (drv: { extraLibraries = (drv.extraLibraries or []) ++ xs; });

  addBuildDepend = drv: x: addBuildDepends drv [x];
  addBuildDepends = drv: xs: overrideCabal drv (drv: { buildDepends = (drv.buildDepends or []) ++ xs; });

  addPkgconfigDepend = drv: x: addPkgconfigDepends drv [x];
  addPkgconfigDepends = drv: xs: overrideCabal drv (drv: { pkgconfigDepends = (drv.pkgconfigDepends or []) ++ xs; });

  addSetupDepend = drv: x: addSetupDepends drv [x];
  addSetupDepends = drv: xs: overrideCabal drv (drv: { setupHaskellDepends = (drv.setupHaskellDepends or []) ++ xs; });

  enableCabalFlag = drv: x: appendConfigureFlag (removeConfigureFlag drv "-f-${x}") "-f${x}";
  disableCabalFlag = drv: x: appendConfigureFlag (removeConfigureFlag drv "-f${x}") "-f-${x}";

  markBroken = drv: overrideCabal drv (drv: { broken = true; });
  markBrokenVersion = version: drv: assert drv.version == version; markBroken drv;

  enableLibraryProfiling = drv: overrideCabal drv (drv: { enableLibraryProfiling = true; });
  disableLibraryProfiling = drv: overrideCabal drv (drv: { enableLibraryProfiling = false; });

  enableSharedExecutables = drv: overrideCabal drv (drv: { enableSharedExecutables = true; });
  disableSharedExecutables = drv: overrideCabal drv (drv: { enableSharedExecutables = false; });

  enableSharedLibraries = drv: overrideCabal drv (drv: { enableSharedLibraries = true; });
  disableSharedLibraries = drv: overrideCabal drv (drv: { enableSharedLibraries = false; });

  enableDeadCodeElimination = drv: overrideCabal drv (drv: { enableDeadCodeElimination = true; });
  disableDeadCodeElimination = drv: overrideCabal drv (drv: { enableDeadCodeElimination = false; });

  enableStaticLibraries = drv: overrideCabal drv (drv: { enableStaticLibraries = true; });
  disableStaticLibraries = drv: overrideCabal drv (drv: { enableStaticLibraries = false; });

  appendPatch = drv: x: appendPatches drv [x];
  appendPatches = drv: xs: overrideCabal drv (drv: { patches = (drv.patches or []) ++ xs; });

  doHyperlinkSource = drv: overrideCabal drv (drv: { hyperlinkSource = true; });
  dontHyperlinkSource = drv: overrideCabal drv (drv: { hyperlinkSource = false; });

  disableHardening = drv: flags: overrideCabal drv (drv: { hardeningDisable = flags; });

  # Controls if Nix should strip the binary files (removes debug symbols)
  doStrip = drv: overrideCabal drv (drv: { dontStrip = false; });
  dontStrip = drv: overrideCabal drv (drv: { dontStrip = true; });

  # Useful for debugging segfaults with gdb.
  # -g: enables debugging symbols
  # --disable-*-stripping: tell GHC not to strip resulting binaries
  # dontStrip: see above
  enableDWARFDebugging = drv:
   appendConfigureFlag (dontStrip drv) "--ghc-options=-g --disable-executable-stripping --disable-library-stripping";

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

  linkWithGold = drv : appendConfigureFlag drv
    "--ghc-option=-optl-fuse-ld=gold --ld-option=-fuse-ld=gold --with-ld=ld.gold";

  # link executables statically against haskell libs to reduce closure size
  justStaticExecutables = drv: overrideCabal drv (drv: {
    enableSharedExecutables = false;
    isLibrary = false;
    doHaddock = false;
    postFixup = "rm -rf $out/lib $out/nix-support $out/share/doc";
  } // lib.optionalAttrs (pkgs.hostPlatform.isDarwin) {
    configureFlags = (drv.configureFlags or []) ++ ["--ghc-option=-optl=-dead_strip"];
  });

  buildFromSdist = pkg: lib.overrideDerivation pkg (drv: {
    unpackPhase = let src = sdistTarball pkg; tarname = "${pkg.pname}-${pkg.version}"; in ''
      echo "Source tarball is at ${src}/${tarname}.tar.gz"
      tar xf ${src}/${tarname}.tar.gz
      cd ${pkg.pname}-*
    '';
  });

  buildStrictly = pkg: buildFromSdist (failOnAllWarnings pkg);

  failOnAllWarnings = drv: appendConfigureFlag drv "--ghc-option=-Wall --ghc-option=-Werror";

  checkUnusedPackages =
    { ignoreEmptyImports ? false
    , ignoreMainModule   ? false
    , ignorePackages     ? []
    } : drv :
      overrideCabal (appendConfigureFlag drv "--ghc-option=-ddump-minimal-imports") (_drv: {
        postBuild = with lib;
          let args = concatStringsSep " " (
                       optional ignoreEmptyImports "--ignore-empty-imports" ++
                       optional ignoreMainModule   "--ignore-main-module" ++
                       map (pkg: "--ignore-package ${pkg}") ignorePackages
                     );
          in "${pkgs.haskellPackages.packunused}/bin/packunused" +
             optionalString (args != "") " ${args}";
      });

  buildStackProject = pkgs.callPackage ./generic-stack-builder.nix { };

  triggerRebuild = drv: i: overrideCabal drv (drv: { postUnpack = ": trigger rebuild ${toString i}"; });

  overrideSrc = drv: { src, version ? drv.version }:
    overrideCabal drv (_: { inherit src version; editedCabalFile = null; });

  # Extract the haskell build inputs of a haskell package.
  # This is useful to build environments for developing on that
  # package.
  getHaskellBuildInputs = p:
    (p.override { mkDerivation = extractBuildInputs p.compiler;
                }).haskellBuildInputs;

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

  # Divide the build inputs of the package into useful sets.
  extractBuildInputs = ghc:
    { setupHaskellDepends ? [], extraLibraries ? []
    , librarySystemDepends ? [], executableSystemDepends ? []
    , pkgconfigDepends ? [], libraryPkgconfigDepends ? []
    , executablePkgconfigDepends ? [], testPkgconfigDepends ? []
    , benchmarkPkgconfigDepends ? [], testDepends ? []
    , testHaskellDepends ? [], testSystemDepends ? []
    , testToolDepends ? [], benchmarkDepends ? []
    , benchmarkHaskellDepends ? [], benchmarkSystemDepends ? []
    , benchmarkToolDepends ? [], buildDepends ? []
    , libraryHaskellDepends ? [], executableHaskellDepends ? []
    , ...
    }@args:
    let inherit (ghcInfo ghc) isGhcjs nativeGhc;
        inherit (controlPhases ghc args) doCheck doBenchmark;
        isHaskellPkg = x: x ? isHaskellLibrary;
        allPkgconfigDepends =
          pkgconfigDepends ++ libraryPkgconfigDepends ++
          executablePkgconfigDepends ++
          lib.optionals doCheck testPkgconfigDepends ++
          lib.optionals doBenchmark benchmarkPkgconfigDepends;
        otherBuildInputs =
          setupHaskellDepends ++ extraLibraries ++
          librarySystemDepends ++ executableSystemDepends ++
          allPkgconfigDepends ++
          lib.optionals doCheck ( testDepends ++ testHaskellDepends ++
                                  testSystemDepends ++ testToolDepends
                                ) ++
          # ghcjs's hsc2hs calls out to the native hsc2hs
          lib.optional isGhcjs nativeGhc ++
          lib.optionals doBenchmark ( benchmarkDepends ++
                                      benchmarkHaskellDepends ++
                                      benchmarkSystemDepends ++
                                      benchmarkToolDepends
                                    );
        propagatedBuildInputs =
          buildDepends ++ libraryHaskellDepends ++
          executableHaskellDepends;
        allBuildInputs = propagatedBuildInputs ++ otherBuildInputs;
        isHaskellPartition =
          lib.partition isHaskellPkg allBuildInputs;
    in
      { haskellBuildInputs = isHaskellPartition.right;
        systemBuildInputs = isHaskellPartition.wrong;
        inherit propagatedBuildInputs otherBuildInputs
          allPkgconfigDepends;
      };

}
