{ haskellLib }:
with haskellLib;
self: super: {
  # Disable GHC 9.0.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  Cabal-syntax = null;
  containers = null;
  deepseq = null;
  directory = null;
  exceptions = null;
  filepath = null;
  ghc-bignum = null;
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
  system-cxx-std-lib = null;
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;
  Win32 = null;

  # Becomes a core package in GHC >= 9.8
  semaphore-compat = doDistribute self.semaphore-compat_1_0_0;

  # Becomes a core package in GHC >= 9.10
  os-string = doDistribute self.os-string_2_0_8;

  # Becomes a core package in GHC >= 9.10, no release compatible with GHC < 9.10 is available
  ghc-internal = null;
  # Become core packages in GHC >= 9.10, but aren't uploaded to Hackage
  ghc-platform = null;
}
