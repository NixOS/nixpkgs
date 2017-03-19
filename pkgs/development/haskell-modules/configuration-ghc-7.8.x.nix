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

  # https://github.com/peti/jailbreak-cabal/issues/9
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = self.Cabal_1_20_0_4; };

  # mtl 2.2.x needs the latest transformers.
  mtl_2_2_1 = super.mtl.override { transformers = self.transformers_0_4_3_0; };

  # Configure mtl 2.1.x.
  mtl = self.mtl_2_1_3_1;
  transformers-compat = addBuildDepend (enableCabalFlag super.transformers-compat "three") self.mtl;
  mtl-compat = addBuildDepend (enableCabalFlag super.mtl-compat "two-point-one") self.transformers-compat;

  # haddock-api 2.16 requires ghc>=7.10
  haddock-api = super.haddock-api_2_15_0_2;

  # This is part of bytestring in our compiler.
  bytestring-builder = dontHaddock super.bytestring-builder;

  # Won't compile against mtl 2.1.x.
  imports = super.imports.override { mtl = self.mtl_2_2_1; };

  # Newer versions require mtl 2.2.x.
  mtl-prelude = self.mtl-prelude_1_0_3;

  # purescript requires mtl 2.2.x.
  purescript = overrideCabal (super.purescript.overrideScope (self: super: {
    mkDerivation = drv: super.mkDerivation (drv // { doCheck = false; });
    mtl = super.mtl_2_2_1;
    transformers = super.transformers_0_4_3_0;
    haskeline = self.haskeline_0_7_3_1;
    transformers-compat = disableCabalFlag super.transformers-compat "three";
  })) (drv: {});

  # The test suite pulls in mtl 2.2.x
  command-qq = dontCheck super.command-qq;

  # Doesn't support GHC < 7.10.x.
  bound-gen = dontDistribute super.bound-gen;
  ghc-exactprint = dontDistribute super.ghc-exactprint;
  ghc-typelits-natnormalise = dontDistribute super.ghc-typelits-natnormalise;

  # Needs directory >= 1.2.2.0.
  idris = markBroken super.idris;

  # Newer versions require transformers 0.4.x.
  seqid = super.seqid_0_1_0;
  seqid-streams = super.seqid-streams_0_1_0;

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
  nats_1 = addBuildDepend super.nats_1 self.hashable;
  nats = addBuildDepend super.nats self.hashable;

  # needs mtl-compat to build with mtl 2.1.x
  cgi = addBuildDepend super.cgi self.mtl-compat;

  # https://github.com/magthe/sandi/issues/7
  sandi = overrideCabal super.sandi (drv: {
    postPatch = "sed -i -e 's|base ==4.8.*,|base,|' sandi.cabal";
  });

  # Overriding mtl 2.2.x is fine here because ghc-events is an stand-alone executable.
  ghc-events = super.ghc-events.override { mtl = self.mtl_2_2_1; };

  # The network library is required in configurations that don't have network-uri.
  hxt = addBuildDepend super.hxt self.network;
  hxt_9_3_1_7 = addBuildDepend super.hxt_9_3_1_7 self.network;
  hxt_9_3_1_10 = addBuildDepend super.hxt_9_3_1_10 self.network;
  hxt_9_3_1_12 = addBuildDepend super.hxt_9_3_1_12 self.network;
  xss-sanitize = addBuildDepend super.xss-sanitize self.network;
  xss-sanitize_0_3_5_4 = addBuildDepend super.xss-sanitize_0_3_5_4 self.network;
  xss-sanitize_0_3_5_5 = addBuildDepend super.xss-sanitize_0_3_5_5 self.network;

  # Needs void on pre 7.10.x compilers.
  conduit = addBuildDepend super.conduit self.void;
  conduit_1_2_5 = addBuildDepend super.conduit_1_2_5 self.void;

  # Needs additional inputs on pre 7.10.x compilers.
  semigroups = addBuildDepends super.semigroups (with self; [nats tagged unordered-containers]);
  lens = addBuildDepends super.lens (with self; [doctest generic-deriving nats simple-reflect]);
  distributive = addBuildDepend super.distributive self.semigroups;

  # Haddock doesn't cope with the new markup.
  bifunctors = dontHaddock super.bifunctors;

}
