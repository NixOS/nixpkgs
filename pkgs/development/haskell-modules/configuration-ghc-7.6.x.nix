{ pkgs }:

with import ./lib.nix { inherit pkgs; };

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
  haskeline = null;
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
  terminfo = null;
  time = null;
  unix = null;

  # transformers is not a core library for this compiler.
  transformers = self.transformers_0_4_2_0;
  mtl = self.mtl_2_2_1;
  transformers-compat = disableCabalFlag super.transformers-compat "three";

  # https://github.com/haskell/cabal/issues/2322
  Cabal_1_22_0_0 = super.Cabal_1_22_0_0.override { binary = self.binary_0_7_2_3; };

  # https://github.com/tibbe/hashable/issues/85
  hashable = dontCheck super.hashable;
}
