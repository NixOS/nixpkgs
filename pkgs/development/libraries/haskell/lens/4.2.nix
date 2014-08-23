{ cabal, aeson, attoparsec, bifunctors, comonad, contravariant
, deepseq, distributive, doctest, exceptions, filepath, free
, genericDeriving, hashable, hlint, HUnit, mtl, nats, parallel
, primitive, profunctors, QuickCheck, reflection, scientific
, semigroupoids, semigroups, simpleReflect, split, tagged
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, testFrameworkTh, text, transformers, transformersCompat
, unorderedContainers, vector, void, zlib
}:

cabal.mkDerivation (self: {
  pname = "lens";
  version = "4.2";
  sha256 = "0aqhr8akb7wg270jxi1ns3mrpv42cfssi3g2kzyhkjmb39qxpp2w";
  buildDepends = [
    aeson attoparsec bifunctors comonad contravariant distributive
    exceptions filepath free hashable mtl parallel primitive
    profunctors reflection scientific semigroupoids semigroups split
    tagged text transformers transformersCompat unorderedContainers
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
