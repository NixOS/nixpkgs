{ cabal, aeson, bifunctors, comonad, constraints, contravariant
, deepseq, distributive, doctest, exceptions, filepath
, genericDeriving, hashable, hlint, HUnit, mtl, nats, parallel
, primitive, profunctors, QuickCheck, reflection, scientific
, semigroupoids, semigroups, simpleReflect, split, tagged
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, testFrameworkTh, text, transformers, transformersCompat
, unorderedContainers, utf8String, vector, void, zlib
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "4.0";
  sha256 = "1mrpbwnj1k2my71lm0ajxsx5r44sz372gfxn78vz4182yv3bmla1";
  buildDepends = [
    aeson bifunctors comonad constraints contravariant distributive
    exceptions filepath hashable mtl parallel primitive profunctors
    reflection scientific semigroupoids semigroups split tagged text
    transformers transformersCompat unorderedContainers utf8String
    vector void zlib
  ];
  testDepends = [
    deepseq doctest filepath genericDeriving hlint HUnit mtl nats
    parallel QuickCheck semigroups simpleReflect split testFramework
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
