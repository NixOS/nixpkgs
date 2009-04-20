{cabal, haskellSrcExts}:

cabal.mkDerivation (self : {
  pname = "haskell-src-meta";
  version = "0.0.3.1";
  sha256 = "74d450fd9d50edfd3cdad5c2860da2af3454b280bd37b401e16e2f492bfb5e15";
  propagatedBuildInputs = [haskellSrcExts];
  meta = {
    description = "Parse source to template-haskell abstract syntax";
  };
})  

