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

  # lts-12.x versions do not compile.
  primitive = self.primitive_0_6_4_0;
  tagged = self.tagged_0_8_6;

  # Over-specified constraints.
  async = doJailbreak super.async;                           # base >=4.3 && <4.12, stm >=2.2 && <2.5
  ChasingBottoms = doJailbreak super.ChasingBottoms;         # base >=4.2 && <4.12, containers >=0.3 && <0.6
  hashable = doJailbreak super.hashable;                     # base >=4.4 && <4.1
  hashable-time = doJailbreak super.hashable-time;           # base >=4.7 && <4.12
  integer-logarithms = doJailbreak super.integer-logarithms; # base >=4.3 && <4.12
  tar = doJailbreak super.tar;                               # containers >=0.2 && <0.6
  test-framework = doJailbreak super.test-framework;         # containers >=0.1 && <0.6

}
