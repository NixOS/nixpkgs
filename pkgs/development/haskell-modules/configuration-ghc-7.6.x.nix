{ pkgs }:

with import ./lib.nix;

self: super: {

  # Disable GHC 7.6.x core libraries.
  array = null;
  base = null;
  binary = null;
  bin-package-db = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
  filepath = null;
  ghc-prim = null;
  haskell2010 = null;
  haskell98 = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  old-locale = null;
  old-time = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  time = null;
  unix = null;

  terminfo = self.terminfo_0_4_0_0;
  haskeline = self.haskeline_0_7_1_3;
  transformers = self.transformers_0_4_2_0;
  mtl = self.mtl_2_2_1;

  Cabal_1_22_0_0 = super.Cabal_1_22_0_0.override { binary = self.binary_0_7_2_3; };
}
