{ }:

self: super: {
  # Disable GHC 9.0.x core libraries.
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
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;
  Win32 = null;

  # core pkgs on later GHCs that we can reasonably provide a stub
  # or Hackage released version for (though they may not build).
  Cabal-syntax = self.Cabal-syntax_3_6_0_0;
  semaphore-compat = self.semaphore-compat_2_0_0;
  os-string = self.os-string_2_0_11;
  file-io = self.file-io_0_2_0;
  # Would need 2.25.*, but let's not bother
  haddock-api = self.haddock-api_2_29_1;
  haddock-library = self.haddock-library_1_11_0;

  # core pkgs on later GHCs we can't provide at all
  system-cxx-std-lib = null;
  ghc-experimental = null;
  ghc-internal = null;
  ghc-platform = null;
  ghc-toolchain = null;
}
