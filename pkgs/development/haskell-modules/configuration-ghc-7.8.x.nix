{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_34;

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
  mtl_2_2_1 = super.mtl.override { transformers = self.transformers_0_4_3_0; };

  # Configure mtl 2.1.x.
  mtl = self.mtl_2_1_3_1;
  transformers-compat = addBuildDepend (enableCabalFlag super.transformers-compat "three") self.mtl;
  mtl-compat = addBuildDepend (enableCabalFlag super.mtl-compat "two-point-one") self.transformers-compat;

  # haddock-api 2.16 requires ghc>=7.10
  haddock-api = super.haddock-api_2_15_0_2;

  # Idris needs special version of some libraries
  idris = let super1 = super; in overrideCabal (super.idris.overrideScope (self: super: {
    annotated-wl-pprint = self.annotated-wl-pprint_0_5_3;
    blaze-html = self.blaze-html_0_7_0_3;
    blaze-markup = self.blaze-markup_0_6_2_0;
    lens = self.lens_4_7_0_1;
  })) (drv: {
    patchPhase = "find . -name '*.hs' -exec sed -i -s 's|-Werror||' {} +";
  });                           # warning: "Module ‘Control.Monad.Error’ is deprecated"

  # Depends on time == 0.1.5, which we don't have.
  HStringTemplate_0_8_3 = dontDistribute super.HStringTemplate_0_8_3;

  # This is part of bytestring in our compiler.
  bytestring-builder = dontHaddock super.bytestring-builder;

  # Won't compile against mtl 2.1.x.
  imports = super.imports.override { mtl = self.mtl_2_2_1; };

  # Newer versions require mtl 2.2.x.
  mtl-prelude = self.mtl-prelude_1_0_3;
  equivalence = super.equivalence_0_2_5;        # required by Agda

  # purescript requires mtl 2.2.x.
  purescript = overrideCabal (super.purescript.overrideScope (self: super: {
    mkDerivation = drv: super.mkDerivation (drv // { doCheck = false; });
    mtl = super.mtl_2_2_1;
    transformers = super.transformers_0_4_3_0;
    haskeline = self.haskeline_0_7_2_1;
    transformers-compat = disableCabalFlag super.transformers-compat "three";
  })) (drv: {});

  # The test suite pulls in mtl 2.2.x
  command-qq = dontCheck super.command-qq;

  # Doesn't support GHC < 7.10.x.
  bound-gen = dontDistribute super.bound-gen;
  ghc-exactprint = dontDistribute super.ghc-exactprint;
  ghc-typelits-natnormalise = dontDistribute super.ghc-typelits-natnormalise;

  # Newer versions require transformers 0.4.x.
  seqid = super.seqid_0_1_0;
  seqid-streams = super.seqid-streams_0_1_0;

  # Need binary >= 0.7.2, but our compiler has only 0.7.1.0.
  hosc = super.hosc.overrideScope (self: super: { binary = self.binary_0_7_4_0; });
  tidal-midi = super.tidal-midi.overrideScope (self: super: { binary = self.binary_0_7_4_0; });

  # These packages need mtl 2.2.x directly or indirectly via dependencies.
  amazonka = markBroken super.amazonka;
  apiary-purescript = markBroken super.apiary-purescript;
  clac = dontDistribute super.clac;
  highlighter2 = markBroken super.highlighter2;
  hypher = markBroken super.hypher;
  miniforth = markBroken super.miniforth;
  xhb-atom-cache = markBroken super.xhb-atom-cache;
  xhb-ewmh = markBroken super.xhb-ewmh;
  yesod-purescript = markBroken super.yesod-purescript;
  yet-another-logger = markBroken super.yet-another-logger;

  # https://github.com/frosch03/arrowVHDL/issues/2
  ArrowVHDL = markBroken super.ArrowVHDL;

  # https://ghc.haskell.org/trac/ghc/ticket/9625
  wai-middleware-preprocessor = dontCheck super.wai-middleware-preprocessor;
  incremental-computing = dontCheck super.incremental-computing;

  # Newer versions require base > 4.7
  gloss = super.gloss_1_9_2_1;

  # Workaround for a workaround, see comment for "ghcjs" flag.
  jsaddle = let jsaddle' = disableCabalFlag super.jsaddle "ghcjs";
            in addBuildDepends jsaddle' [ self.glib self.gtk3 self.webkitgtk3
                                          self.webkitgtk3-javascriptcore ];

  # Needs hashable on pre 7.10.x compilers.
  nats = addBuildDepend super.nats self.hashable;

  # needs mtl-compat to build with mtl 2.1.x
  cgi = addBuildDepend super.cgi self.mtl-compat;

  # Newer versions always trigger the non-deterministic library ID bug
  # and are virtually impossible to compile on Hydra.
  conduit = super.conduit_1_2_4_1;

  # https://github.com/magthe/sandi/issues/7
  sandi = overrideCabal super.sandi (drv: {
    patchPhase = "sed -i -e 's|base ==4.8.*,|base,|' sandi.cabal"; }
  );

}
