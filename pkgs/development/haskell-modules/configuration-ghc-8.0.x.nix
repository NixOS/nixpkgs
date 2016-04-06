{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {

  # Suitable LLVM version.
  llvmPackages = pkgs.llvmPackages_35;

  # Disable GHC 8.0.x core libraries.
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
  ghc-prim = null;
  ghci = null;
  haskeline = null;
  hoopl = null;
  hpc = null;
  integer-gmp = null;
  pretty = null;
  process = null;
  rts = null;
  template-haskell = null;
  terminfo = null;
  time = null;
  transformers = null;
  unix = null;
  xhtml = null;

  # cabal-install can use the native Cabal library.
  cabal-install = super.cabal-install.override { Cabal = null; };

  # jailbreak-cabal can use the native Cabal library.
  jailbreak-cabal = super.jailbreak-cabal.override { Cabal = null; };

  # https://github.com/hspec/HUnit/issues/7
  HUnit = dontCheck super.HUnit;

  # https://github.com/hspec/hspec/issues/253
  hspec-core = dontCheck super.hspec-core;

  # Deviate from Stackage here to fix lots of builds.
  transformers-compat = super.transformers-compat_0_5_1_4;

  # https://github.com/sol/doctest/issues/125
  doctest = self.doctest_0_11_0;

  # No modules defined for this compiler.
  fail = dontHaddock super.fail;

  # Version 4.x doesn't compile with transformers 0.5 or later.
  comonad_5 = dontCheck super.comonad_5;  # https://github.com/ekmett/comonad/issues/33
  comonad = self.comonad_5;

}
