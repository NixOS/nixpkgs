{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Disable GHC 7.8.x core libraries.
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
  haskeline = self.haskeline_0_7_1_3;   # GHC's version is broken: https://github.com/NixOS/nixpkgs/issues/5616.
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
  terminfo = self.terminfo_0_4_0_0;     # GHC's version is broken: https://github.com/NixOS/nixpkgs/issues/5616.
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # mtl 2.2.x needs the latest transformers.
  mtl_2_2_1 = super.mtl_2_2_1.override { transformers = self.transformers_0_4_2_0; };
}
