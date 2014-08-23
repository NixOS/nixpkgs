{ cabal, bifunctors, comonad, contravariant, deepseq, distributive
, doctest, exceptions, filepath, free, genericDeriving, hashable
, hlint, HUnit, mtl, nats, parallel, primitive, profunctors
, QuickCheck, reflection, semigroupoids, semigroups, simpleReflect
, split, tagged, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, testFrameworkTh, text, transformers
, transformersCompat, unorderedContainers, vector, void, zlib
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "4.4";
  sha256 = "06ha4px4ywfbi0n3imy2qqjq3656snsz1b0ggkwzvdzmi550sh8w";
  buildDepends = [
    bifunctors comonad contravariant distributive exceptions filepath
    free hashable mtl parallel primitive profunctors reflection
    semigroupoids semigroups split tagged text transformers
    transformersCompat unorderedContainers vector void zlib
  ];
  testDepends = [
    deepseq doctest filepath genericDeriving hlint HUnit mtl nats
    parallel QuickCheck semigroups simpleReflect split testFramework
    testFrameworkHunit testFrameworkQuickcheck2 testFrameworkTh text
    transformers unorderedContainers vector
  ];
  meta = {
    homepage = "http://github.com/ekmett/lens/";
    description = "Lenses, Folds and Traversals";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
