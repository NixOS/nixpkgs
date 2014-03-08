{ cabal, async, conduit, doctest, filepath, free, hspec
, hspecExpectationsLens, httpClient, httpConduit, httpTypes, lens
, monadControl, network, text, transformers, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "libjenkins";
  version = "0.4.2.0";
  sha256 = "11013klk2gvcaf2d2gmi0bf3jg2m82li19szqlwb325kdjmdf546";
  buildDepends = [
    async conduit free httpClient httpConduit httpTypes lens
    monadControl network text transformers xmlConduit
  ];
  testDepends = [
    async conduit doctest filepath free hspec hspecExpectationsLens
    httpClient httpConduit httpTypes lens monadControl network text
    transformers xmlConduit
  ];
  doCheck = false;
  meta = {
    description = "Jenkins API interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
