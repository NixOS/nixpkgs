{ cabal } :

cabal.mkDerivation (self : {
  pname = "ghc-paths";
  version = "0.1.0.5";
  sha256 = "ea9e97425894e3dbd7915e00e107e2e7fc07b6e8293fd2dd66a813f0673cba10";
  meta = {
    description = "Knowledge of GHC's installations directories";
  };
})

