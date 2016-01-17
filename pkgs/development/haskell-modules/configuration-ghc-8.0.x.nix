{ pkgs }:

with import ./lib.nix { inherit pkgs; };

self: super: {
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

  Cabal_1_23_0_0 = overrideCabal super.Cabal_1_22_4_0 (drv: {
    version = "1.23.0.0";
    src = pkgs.fetchFromGitHub {
      owner = "haskell";
      repo = "cabal";
      rev = "18fcd9c1aaeddd9d10a25e44c0e986c9889f06a7";
      sha256 = "1bakw7h5qadjhqbkmwijg3588mjnpvdhrn8lqg8wq485cfcv6vn3";
    };
    jailbreak = false;
    doHaddock = false;
    postUnpack = "sourceRoot+=/Cabal";
    postPatch = ''
      setupCompileFlags+=" -DMIN_VERSION_binary_0_8_0=1"
    '';
  });
  jailbreak-cabal = super.jailbreak-cabal.override {
    Cabal = self.Cabal_1_23_0_0;
    mkDerivation = drv: self.mkDerivation (drv // {
      preConfigure = "sed -i -e 's/Cabal == 1.20\\.\\*/Cabal >= 1.23/' jailbreak-cabal.cabal";
    });
  };
}
