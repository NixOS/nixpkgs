{ cabal, bifunctors, comonad, comonadsFd, comonadTransformers
, contravariant, deepseq, distributive, doctest, filepath
, genericDeriving, hashable, HUnit, MonadCatchIOTransformers, mtl
, nats, parallel, profunctorExtras, profunctors, QuickCheck
, reflection, semigroupoids, semigroups, simpleReflect, split
, tagged, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, testFrameworkTh, text, transformers
, transformersCompat, unorderedContainers, vector, void
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "3.9.2";
  sha256 = "17pc0waf3g6dxvmvyxkgh8kz22iscd9z00s67rcn0p604swprj2k";
  buildDepends = [
    bifunctors comonad comonadsFd comonadTransformers contravariant
    distributive filepath genericDeriving hashable
    MonadCatchIOTransformers mtl parallel profunctorExtras profunctors
    reflection semigroupoids semigroups split tagged text transformers
    transformersCompat unorderedContainers vector void
  ];
  testDepends = [
    deepseq doctest filepath genericDeriving HUnit mtl nats parallel
    QuickCheck semigroups simpleReflect split testFramework
    testFrameworkHunit testFrameworkQuickcheck2 testFrameworkTh text
    transformers unorderedContainers vector
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/ekmett/lens/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
