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
  brick = self.brick_0_44_1;
  cassava-megaparsec = doJailbreak super.cassava-megaparsec;
  config-ini = doJailbreak super.config-ini;   # https://github.com/aisamanra/config-ini/issues/18
  contravariant = self.contravariant_1_5;
  fgl = self.fgl_5_7_0_1;
  free = self.free_5_1;
  haddock-library = dontCheck super.haddock-library_1_7_0;
  HaTeX = doJailbreak super.HaTeX;
  hpack = self.hpack_0_31_1;
  hslua = self.hslua_1_0_1;
  hslua-module-text = self.hslua-module-text_0_2_0;
  hspec = self.hspec_2_6_0;
  hspec-contrib = self.hspec-contrib_0_5_1;
  hspec-core = self.hspec-core_2_6_0;
  hspec-discover = self.hspec-discover_2_6_0;
  hspec-megaparsec = doJailbreak super.hspec-megaparsec;  # newer versions need megaparsec 7.x
  hspec-meta = self.hspec-meta_2_6_0;
  JuicyPixels = self.JuicyPixels_3_3_2;
  lens = self.lens_4_17;
  megaparsec = dontCheck (doJailbreak super.megaparsec);
  pandoc = self.pandoc_2_5;
  pandoc-citeproc = self.pandoc-citeproc_0_15;
  pandoc-citeproc_0_15 = doJailbreak super.pandoc-citeproc_0_15;
  patience = markBrokenVersion "0.1.1" super.patience;
  polyparse = self.polyparse_1_12_1;
  primitive = self.primitive_0_6_4_0;
  QuickCheck = self.QuickCheck_2_12_6_1;
  semigroupoids = self.semigroupoids_5_3_1;
  tagged = self.tagged_0_8_6;
  vty = self.vty_5_25_1;
  wizards = doJailbreak super.wizards;
  wl-pprint-extras = doJailbreak super.wl-pprint-extras;
  yaml = self.yaml_0_11_0_0;

  # https://github.com/tibbe/unordered-containers/issues/214
  unordered-containers = dontCheck super.unordered-containers;

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

  # https://github.com/jgm/skylighting/issues/55
  skylighting-core = dontCheck super.skylighting-core;

  # Break out of "yaml >=0.10.4.0 && <0.11".
  stack = doJailbreak super.stack;

}
