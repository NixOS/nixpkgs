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
  transformers-compat = self.transformers-compat_0_5_1_4;

  # No modules defined for this compiler.
  fail = dontHaddock super.fail;

  # Version 4.x doesn't compile with transformers 0.5 or later.
  comonad_5 = dontCheck super.comonad_5;  # https://github.com/ekmett/comonad/issues/33
  comonad = self.comonad_5;

  # Versions <= 5.2 don't compile with transformers 0.5 or later.
  bifunctors = self.bifunctors_5_3;

  # https://github.com/ekmett/semigroupoids/issues/42
  semigroupoids = dontCheck super.semigroupoids;

  # Version 4.x doesn't compile with transformers 0.5 or later.
  kan-extensions = self.kan-extensions_5_0_1;

  # Earlier versions don't support kan-extensions 5.x.
  lens = self.lens_4_14;

  # https://github.com/dreixel/generic-deriving/issues/37
  generic-deriving = dontHaddock super.generic-deriving;

  # https://github.com/haskell-suite/haskell-src-exts/issues/302
  haskell-src-exts = dontCheck super.haskell-src-exts;

  active         = doJailbreak super.active;

  authenticate-oauth = doJailbreak super.authenticate-oauth;

  diagrams-core  = doJailbreak super.diagrams-core;

  diagrams-lib   = doJailbreak super.diagrams-lib;

}
