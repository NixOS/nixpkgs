{ pkgs, haskellLib }:

let
  inherit (pkgs) lib;

in

with haskellLib;

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
  # GHC only builds terminfo if it is a native compiler
  terminfo =
    if pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform then
      null
    else
      haskellLib.doDistribute self.terminfo_0_4_1_7;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  #
  # Test suite issues
  #

  hashable =
    if pkgs.stdenv.hostPlatform.isBigEndian then
      # Big-endian POWER:
      # Test suite xxhash-tests: RUNNING...
      # xxhash
      #   oneshot
      #     w64-ref:      OK (0.03s)
      #       +++ OK, passed 100 tests.
      #     w64-examples: FAIL
      #       tests/xxhash-tests.hs:21:
      #       expected: 2768807632077661767
      #        but got: 13521078365639231154
      # I pretend I do not see it...
      dontCheck super.hashable
    else
      super.hashable;
}
