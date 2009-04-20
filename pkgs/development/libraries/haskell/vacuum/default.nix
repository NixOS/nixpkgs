{cabal, ghcPaths, haskellSrcMeta}:

cabal.mkDerivation (self : {
  pname = "vacuum";
  version = "0.0.91";
  sha256 = "9240ec35b39d60928a73469893adf1d2aa742b9a781dbc6dcdaa54e96d9bf1af";
  propagatedBuildInputs = [ghcPaths haskellSrcMeta];
  meta = {
    description = "Generic programming with systems of recursive datatypes";
  };
})  

