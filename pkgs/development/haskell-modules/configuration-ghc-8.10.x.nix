{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 9.x.
  llvmPackages = pkgs.llvmPackages_9;

  # Disable GHC 8.10.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  exceptions = null;
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

  # Jailbreak to fix the build.
  async = doJailbreak super.async;
  hashable = doJailbreak super.hashable;
  primitive_0_7_0_0 = doJailbreak (dontCheck super.primitive_0_7_0_0);  # evaluating the test suite gives an infinite recursion
  regex-base_0_94_0_0 = doJailbreak super.regex-base_0_94_0_0;
  regex-compat_0_95_2_0 = doJailbreak super.regex-compat_0_95_2_0;
  regex-posix_0_96_0_0 = doJailbreak super.regex-posix_0_96_0_0;
  tar = doJailbreak super.tar;
  tasty-expected-failure = doJailbreak super.tasty-expected-failure;
  unliftio-core = doJailbreak super.unliftio-core;
  vector = doJailbreak super.vector;
  zlib = doJailbreak super.zlib;
  parallel = doJailbreak super.parallel;
  split = doJailbreak super.split;

  # Use the latest version to fix the build.
  generic-deriving = self.generic-deriving_1_13_1;
  optparse-applicative = self.optparse-applicative_0_15_1_0;
  primitive = self.primitive_0_7_0_0;
  regex-base = self.regex-base_0_94_0_0;
  regex-compat = self.regex-compat_0_95_2_0;
  regex-pcre-builtin = self.regex-pcre-builtin_0_95_1_1_8_43;
  regex-posix = self.regex-posix_0_96_0_0;
  regex-tdfa = self.regex-tdfa_1_3_1_0;

}
