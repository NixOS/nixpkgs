{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # Use the latest LLVM.
  inherit (pkgs) llvmPackages;

  # Disable GHC 8.4.x core libraries.
  #
  # Verify against:
  # ls /nix/store/wnh3kxra586h9wvxrn62g4lmsri2akds-ghc-8.4.20180115/lib/ghc-8.4.20180115/ -1 | sort | grep -e '-' | grep -Ev '(txt|h|targets)$'
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  bin-package-db = null;
  ghc-boot = null;
  ghc-boot-th = null;
  ghc-compact = null;
  ghci = null;
  ghc-prim = null;
  haskeline = null;
  hpc = null;
  integer-gmp = null;
  mtl = null;
  parsec = null;
  pretty = null;
  process = null;
  stm = null;
  template-haskell = null;
  terminfo = null;
  text = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;
}
