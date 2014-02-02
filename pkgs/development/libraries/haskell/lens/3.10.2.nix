{ cabal, bifunctors, comonad, contravariant, deepseq, distributive
, doctest, filepath, genericDeriving, hashable, HUnit
, MonadCatchIOTransformers, mtl, nats, parallel, profunctors
, QuickCheck, reflection, semigroupoids, semigroups, simpleReflect
, split, tagged, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, testFrameworkTh, text, transformers
, transformersCompat, unorderedContainers, vector, void
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "3.10.2";
  sha256 = "0hdj75sg8r1m2jdpfh81zdcwbhp6mb7xipp6q57pv6n90xc6dnxw";
  buildDepends = [
    bifunctors comonad contravariant distributive filepath
    genericDeriving hashable MonadCatchIOTransformers mtl parallel
    profunctors reflection semigroupoids semigroups split tagged text
    transformers transformersCompat unorderedContainers vector void
  ];
  testDepends = [
    deepseq doctest filepath genericDeriving HUnit mtl nats parallel
    QuickCheck semigroups simpleReflect split testFramework
    testFrameworkHunit testFrameworkQuickcheck2 testFrameworkTh text
    transformers unorderedContainers vector
  ];
  patchPhase = ''
    sed -i lens.cabal -e 's|MonadCatchIO-transformers >=.*,|MonadCatchIO-transformers,|'
  '';
  doCheck = false;
  meta = {
    homepage = "http://github.com/ekmett/lens/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
