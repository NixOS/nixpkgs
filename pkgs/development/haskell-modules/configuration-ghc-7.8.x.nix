{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Disable GHC 7.8.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-prim = null;
  haskeline = null;
  haskell2010 = null;
  haskell98 = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  old-locale = null;
  old-time = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # mtl 2.2.x needs the latest transformers.
  mtl_2_2_1 = super.mtl_2_2_1.override { transformers = self.transformers_0_4_2_0; };

  # Configure build for mtl 2.1.x.
  mtl-compat = addBuildDepend (enableCabalFlag super.mtl-compat "two-point-one") self.transformers-compat;

  # Idris requires mtl 2.2.x.
  idris = overrideCabal (super.idris.overrideScope (self: super: {
    mkDerivation = drv: super.mkDerivation (drv // { doCheck = false; });
    transformers = super.transformers_0_4_2_0;
    transformers-compat = disableCabalFlag super.transformers-compat "three";
    haskeline = self.haskeline_0_7_1_3;
    mtl = super.mtl_2_2_1;
  })) (drv: {
    jailbreak = true;           # idris is scared of lens 4.7
    patchPhase = "find . -name '*.hs' -exec sed -i -s 's|-Werror||' {} +";
  });                           # warning: "Module ‘Control.Monad.Error’ is deprecated"

  # Depends on time == 0.1.5, which we don't have.
  HStringTemplate_0_8_1 = dontDistribute super.HStringTemplate_0_8_1;

  # This is part of bytestring in our compiler.
  bytestring-builder = dontHaddock super.bytestring-builder;

  # Won't compile against mtl 2.1.x.
  imports = super.imports.override { mtl = self.mtl_2_2_1; };

  # Newer versions require mtl 2.2.x.
  mtl-prelude = self.mtl-prelude_1_0_3;

  # The test suite pulls in mtl 2.2.x
  command-qq = dontCheck super.command-qq;

  # Doesn't support GHC < 7.10.x.
  ghc-exactprint = dontDistribute super.ghc-exactprint;

  # Newer versions require transformers 0.4.x.
  seqid = super.seqid_0_1_0;
  seqid-streams = super.seqid-streams_0_1_0;

  # Need binary >= 0.7.2, but our compiler has only 0.7.1.0.
  hosc = dontDistribute super.hosc;
  tidal-midi = dontDistribute super.tidal-midi;

  # Needs mtl 2.2.x due to "plailude".
  clac = dontDistribute super.clac;

  # These packages need mtl 2.2.x directly or indirectly via dependencies.
  apiary-purescript = markBroken super.apiary-purescript;
  highlighter2 = markBroken super.highlighter2;
  hypher = markBroken super.hypher;
  purescript = markBroken super.purescript;
  xhb-atom-cache = markBroken super.xhb-atom-cache;
  xhb-ewmh = markBroken super.xhb-ewmh;
  yesod-purescript = markBroken super.yesod-purescript;
  yet-another-logger = markBroken super.yet-another-logger;

  # https://github.com/frosch03/arrowVHDL/issues/2
  ArrowVHDL = markBroken super.ArrowVHDL;

  # https://ghc.haskell.org/trac/ghc/ticket/9625
  wai-middleware-preprocessor = dontCheck super.wai-middleware-preprocessor;
  incremental-computing = dontCheck super.incremental-computing;

}

// # packages relating to amazonka

(let
  Cabal = self.Cabal_1_18_1_6.overrideScope amazonkaEnv;
  amazonkaEnv = self: super: {
    mkDerivation = drv: super.mkDerivation (drv // {
      doCheck = false;
      hyperlinkSource = false;
      buildTools = (drv.buildTools or []) ++ [ (
        if pkgs.stdenv.lib.elem drv.pname [
          "Cabal"
          "time"
          "unix"
          "directory"
          "process"
          "jailbreak-cabal"
        ] then null else Cabal
      ) ];
    });
    mtl = self.mtl_2_2_1;
    transformers = self.transformers_0_4_2_0;
    transformers-compat = disableCabalFlag super.transformers-compat "three";
    hscolour = super.hscolour;
    time = self.time_1_5_0_1;
    unix = self.unix_2_7_1_0;
    directory = self.directory_1_2_1_0;
    process = overrideCabal self.process_1_2_2_0 (drv: { coreSetup = true; });
    inherit amazonka-core amazonkaEnv amazonka amazonka-cloudwatch amazonka-glacier amazonka-ecs;
  };
  amazonka = super.amazonka.overrideScope amazonkaEnv;
  amazonka-cloudwatch = super.amazonka-cloudwatch.overrideScope amazonkaEnv;
  amazonka-core = super.amazonka-core.overrideScope amazonkaEnv;
  amazonka-ecs = super.amazonka-ecs.overrideScope amazonkaEnv;
  amazonka-glacier = super.amazonka-glacier.overrideScope amazonkaEnv;
  amazonka-kms = super.amazonka-kms.overrideScope amazonkaEnv;
in {
  inherit amazonkaEnv;
  inherit amazonka amazonka-cloudwatch amazonka-core amazonka-ecs amazonka-kms amazonka-glacier;
})
