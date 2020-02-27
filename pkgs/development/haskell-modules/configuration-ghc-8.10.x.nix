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
  ChasingBottoms = doJailbreak super.ChasingBottoms;
  hashable = doJailbreak super.hashable;
  parallel = doJailbreak super.parallel;
  regex-base = doJailbreak super.regex-base;
  regex-compat = doJailbreak super.regex-compat;
  regex-pcre-builtin = doJailbreak super.regex-pcre-builtin;
  regex-posix = doJailbreak super.regex-posix;
  regex-tdfa = doJailbreak super.regex-tdfa;
  split = doJailbreak super.split;
  tar = doJailbreak super.tar;
  tasty-expected-failure = doJailbreak super.tasty-expected-failure;
  unliftio-core = doJailbreak super.unliftio-core;
  vector = doJailbreak super.vector;
  zlib = doJailbreak super.zlib;

  # Use the latest version to fix the build.

}
