{ cabal, caseInsensitive, hspec, httpTypes, QuickCheck
, quickcheckInstances
}:

cabal.mkDerivation (self: {
  pname = "http-kit";
  version = "0.2.2";
  sha256 = "09pq3wzcg8piil6bcp713dfscrfald155456dfir9dljviamhvsv";
  buildDepends = [ caseInsensitive httpTypes ];
  testDepends = [ hspec httpTypes QuickCheck quickcheckInstances ];
  meta = {
    description = "A low-level HTTP library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
