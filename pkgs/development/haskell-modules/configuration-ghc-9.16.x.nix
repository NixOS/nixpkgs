{ pkgs, haskellLib }:

let
  inherit (pkgs) lib;

in

self: super: {
  # Disable GHC core libraries
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
  file-io = null;
  filepath = null;
  ghc-bignum = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghc-experimental = null;
  ghc-heap = null;
  ghc-internal = null;
  ghc-platform = null;
  ghc-prim = null;
  ghc-toolchain = null;
  ghci = null;
  haddock-api = null;
  haddock-library = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  mtl = null;
  os-string = null;
  parsec = null;
  pretty = null;
  process = null;
  rts = null;
  semaphore-compat = null;
  stm = null;
  system-cxx-std-lib = null;
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;
}
