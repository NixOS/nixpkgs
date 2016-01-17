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

  # jailbreak-cabal can use the native Cabal library.
  jailbreak-cabal = super.jailbreak-cabal.override {
    Cabal = null;
    mkDerivation = drv: self.mkDerivation (drv // {
      preConfigure = "sed -i -e 's/Cabal == 1.20\\.\\*/Cabal >= 1.23/' jailbreak-cabal.cabal";
    });
  };

  # Older versions of QuickCheck don't support our version of Template Haskell.
  QuickCheck = self.QuickCheck_2_8_2;

  # Older versions don't support our version of transformers.
  transformers-compat = self.transformers-compat_0_5_1_4;

  # https://github.com/hspec/HUnit/issues/7
  HUnit = dontCheck super.HUnit;

}
