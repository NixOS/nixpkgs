{ cabal, doctest, haskellSrcMeta, hspec, QuickCheck
, quickcheckInstances, text
}:

cabal.mkDerivation (self: {
  pname = "interpolate";
  version = "0.0.2";
  sha256 = "0l9hrgwmvp7h2mgw90gk45zgp0yy00201ki9hwg26sh2wd0sj6f8";
  buildDepends = [ haskellSrcMeta ];
  testDepends = [
    doctest haskellSrcMeta hspec QuickCheck quickcheckInstances text
  ];
  meta = {
    description = "String interpolation done right";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
