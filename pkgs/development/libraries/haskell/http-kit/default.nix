{ cabal, caseInsensitive, hspec, httpTypes, QuickCheck
, quickcheckInstances
}:

cabal.mkDerivation (self: {
  pname = "http-kit";
  version = "0.5.1";
  sha256 = "1swnvsbaabk946pys9q9kr0bgdvalnznd59dw981sg7cywqdcz28";
  buildDepends = [ caseInsensitive httpTypes ];
  testDepends = [ hspec httpTypes QuickCheck quickcheckInstances ];
  meta = {
    description = "A low-level HTTP library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
