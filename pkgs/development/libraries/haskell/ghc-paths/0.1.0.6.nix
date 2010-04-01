{ cabal } :

cabal.mkDerivation (self : {
  pname = "ghc-paths";
  version = "0.1.0.6";
  sha256 = "95d8c0e6ce2f182d792e910149b3c81c381b7d2c2052ffc6d96128b071c55243";
  meta = {
    description = "Knowledge of GHC's installations directories";
  };
})  

