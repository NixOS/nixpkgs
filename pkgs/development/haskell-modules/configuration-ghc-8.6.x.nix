{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 5.x.
  llvmPackages = pkgs.llvmPackages_5;

  # Disable GHC 8.6.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-heap = null;
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  libiserv = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  stm = null;
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # Use to be a core-library, but no longer is since GHC 8.4.x.
  hoopl = self.hoopl_3_10_2_2;

  # LTS-12.x versions do not compile.
  base-orphans = self.base-orphans_0_8;
  brick = self.brick_0_41_2;
  cassava-megaparsec = doJailbreak super.cassava-megaparsec;
  config-ini = doJailbreak super.config-ini;   # https://github.com/aisamanra/config-ini/issues/18
  contravariant = self.contravariant_1_5;
  free = self.free_5_1;
  haddock-library = dontCheck super.haddock-library_1_7_0;
  HaTeX = doJailbreak super.HaTeX;
  hledger = doJailbreak super.hledger;
  hledger-lib = doJailbreak super.hledger-lib;
  hledger-ui = doJailbreak super.hledger-ui;
  hpack = self.hpack_0_31_1;
  hslua = self.hslua_1_0_1;
  hslua-module-text = self.hslua-module-text_0_2_0;
  hspec = self.hspec_2_5_8;
  hspec-core = self.hspec-core_2_5_8;
  hspec-discover = self.hspec-discover_2_5_8;
  hspec-megaparsec = doJailbreak super.hspec-megaparsec;  # newer versions need megaparsec 7.x
  hspec-meta = self.hspec-meta_2_5_6;
  JuicyPixels = self.JuicyPixels_3_3_2;
  lens = self.lens_4_17;
  megaparsec = dontCheck (doJailbreak super.megaparsec);
  neat-interpolation = dontCheck super.neat-interpolation;  # test suite depends on broken HTF
  patience = markBrokenVersion "0.1.1" super.patience;
  polyparse = self.polyparse_1_12_1;
  primitive = self.primitive_0_6_4_0;
  QuickCheck = self.QuickCheck_2_12_6_1;
  semigroupoids = self.semigroupoids_5_3_1;
  tagged = self.tagged_0_8_6;
  vty = self.vty_5_25;
  wizards = doJailbreak super.wizards;
  wl-pprint-extras = doJailbreak super.wl-pprint-extras;
  yaml = self.yaml_0_11_0_0;

  # https://github.com/tibbe/unordered-containers/issues/214
  unordered-containers = dontCheck super.unordered-containers;

  # https://github.com/haskell/fgl/issues/79
  # https://github.com/haskell/fgl/issues/81
  fgl = appendPatch (overrideCabal super.fgl (drv: { editedCabalFile = null; })) ./patches/fgl-monad-fail.patch;

  # Test suite does not compile.
  cereal = dontCheck super.cereal;
  data-clist = doJailbreak super.data-clist;  # won't cope with QuickCheck 2.12.x
  Diff = dontCheck super.Diff;
  http-api-data = doJailbreak super.http-api-data;
  persistent-sqlite = dontCheck super.persistent-sqlite;
  psqueues = dontCheck super.psqueues;    # won't cope with QuickCheck 2.12.x
  system-fileio = dontCheck super.system-fileio;  # avoid dependency on broken "patience"
  unicode-transforms = dontCheck super.unicode-transforms;
  monad-par = dontCheck super.monad-par;  # https://github.com/simonmar/monad-par/issues/66

  # https://github.com/bmillwood/haskell-src-meta/pull/80
  haskell-src-meta = doJailbreak super.haskell-src-meta;

  # https://github.com/skogsbaer/HTF/issues/69
  HTF = markBrokenVersion "0.13.2.4" super.HTF;

  # https://github.com/jgm/skylighting/issues/55
  skylighting-core = dontCheck super.skylighting-core;

  # https://github.com/jgm/pandoc/issues/4974
  pandoc = doJailbreak super.pandoc_2_3_1;

  # Break out of "yaml >=0.10.4.0 && <0.11".
  stack = doJailbreak super.stack;

}
