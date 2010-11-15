{cabal, ghcSyb}:

cabal.mkDerivation (self : {
  pname = "ghc-syb-utils";
  version = "0.2.0.0";
  sha256 = "457110f7e1f163ccf78acb898f8ca43b6a5b4595156a08a2f1a3d81f944d74a9";
  propagatedBuildInputs = [ghcSyb];
  meta = {
    description = "Scrap Your Boilerplate utilities for the GHC API";
  };
})
