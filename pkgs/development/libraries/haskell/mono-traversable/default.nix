{ cabal, comonad, foldl, hashable, hspec, QuickCheck, semigroupoids
, semigroups, text, transformers, unorderedContainers, vector
, vectorAlgorithms, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.4.0.1";
  sha256 = "049skbjwz49c9qz2nys2hn6pc4gqn1a91b5kl9z6hjs9fnaic6ng";
  buildDepends = [
    comonad hashable semigroupoids semigroups text transformers
    unorderedContainers vector vectorAlgorithms vectorInstances
  ];
  testDepends = [
    foldl hspec QuickCheck semigroups text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/mono-traversable";
    description = "Type classes for mapping, folding, and traversing monomorphic containers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
