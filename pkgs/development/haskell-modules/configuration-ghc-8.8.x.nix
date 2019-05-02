{ pkgs, haskellLib }:

with haskellLib;

self: super: {

  # This compiler version needs llvm 7.x.
  llvmPackages = pkgs.llvmPackages_7;

  # Disable GHC 8.8.x core libraries.
  array = null;
  base = null;
  binary = null;
  bytestring = null;
  Cabal = null;
  containers = null;
  deepseq = null;
  directory = null;
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

  # Ignore overly restrictive upper version bounds.
  doctest = doJailbreak super.doctest;

  # These packages don't work and need patching and/or an update.
  primitive = overrideSrc (doJailbreak super.primitive) {
    version = "20180530-git";
    src = pkgs.fetchFromGitHub {
      owner = "haskell";
      repo = "primitive";
      rev = "97964182881aa0419546e0bb188b2d17e4468324";
      sha256 = "1p1pinca33vd10iy7hl20c1fc99vharcgcai6z3ngqbq50k2pd3q";
    };
  };
  colour = appendPatch super.colour (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/colour-2.3.4.patch";
    sha256 = "1h318dczml9qrmfvlz1d12iji86klaxvz63k9g9awibwz8lw2i79";
  });
  dlist = appendPatch super.dlist (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/dlist-0.8.0.6.patch";
    sha256 = "0lkhibfxfk6mi796mrjgmbb50hbyjgc7xdinci64dahj8325jlpc";
  });
  QuickCheck = appendPatch super.QuickCheck (pkgs.fetchpatch {
    url = "https://raw.githubusercontent.com/hvr/head.hackage/master/patches/QuickCheck-2.13.1.patch";
    sha256 = "138yrp3x5cnvncimrnhnkawz6clyk7fj3sr3y93l5szfr11kcvbl";
  });

}
