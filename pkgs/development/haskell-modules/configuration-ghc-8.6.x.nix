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
  contravariant = self.contravariant_1_5;
  control-monad-free = markBrokenVersion "0.6.1" super.control-monad-free;
  Glob = self.Glob_0_9_3;
  haddock-library = markBroken super.haddock-library;
  hslogger = self.hslogger_1_2_12;
  hspec = self.hspec_2_5_8;
  hspec-core = self.hspec-core_2_5_8;
  hspec-core_2_5_8 = super.hspec-core_2_5_8.overrideScope (self: super: { QuickCheck = self.QuickCheck_2_12_5; });
  hspec-discover = self.hspec-discover_2_5_8;
  hspec-meta = self.hspec-meta_2_5_6;
  hspec-meta_2_5_6 = super.hspec-meta_2_5_6.overrideScope (self: super: { QuickCheck = self.QuickCheck_2_12_5; });
  JuicyPixels = self.JuicyPixels_3_3_1;
  lens = dontCheck super.lens;    # avoid depending on broken polyparse
  polyparse = markBrokenVersion "1.12" super.polyparse;
  primitive = self.primitive_0_6_4_0;
  semigroupoids = self.semigroupoids_5_3_1;
  tagged = self.tagged_0_8_6;
  unordered-containers = dontCheck super.unordered-containers;

  # Over-specified constraints.
  async = doJailbreak super.async;                           # base >=4.3 && <4.12, stm >=2.2 && <2.5
  ChasingBottoms = doJailbreak super.ChasingBottoms;         # base >=4.2 && <4.12, containers >=0.3 && <0.6
  hashable = doJailbreak super.hashable;                     # base >=4.4 && <4.1
  hashable-time = doJailbreak super.hashable-time;           # base >=4.7 && <4.12
  integer-logarithms = doJailbreak super.integer-logarithms; # base >=4.3 && <4.12
  optparse-applicative = doJailbreak super.optparse-applicative;   # https://github.com/pcapriotti/optparse-applicative/issues/319
  tar = doJailbreak super.tar;                               # containers >=0.2 && <0.6
  test-framework = doJailbreak super.test-framework;         # containers >=0.1 && <0.6

  # https://github.com/haskell/fgl/issues/79
  # https://github.com/haskell/fgl/issues/81
  fgl = appendPatch super.fgl ./patches/fgl-monad-fail.patch;

  # https://github.com/jgm/texmath/pull/121
  texmath = appendPatch (doJailbreak super.texmath) (pkgs.fetchpatch
            { url = https://github.com/jgm/texmath/pull/121.patch;
              sha256 = "14pz2cpz9rvmy7mlmnz8iz76rsdyv5v442ij2i8k9zrbxj6nai7l";
            });

}
