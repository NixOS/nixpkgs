{ cabal, comonad, dlist, dlistInstances, foldl, hashable, hspec
, QuickCheck, semigroupoids, semigroups, text, transformers
, unorderedContainers, vector, vectorAlgorithms, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.6.0.3";
  sha256 = "1zg8hig4wgbiswb0sppjiga1r6sw7fjkxfiwlck4bwvghpyr5bp3";
  buildDepends = [
    comonad dlist dlistInstances hashable semigroupoids semigroups text
    transformers unorderedContainers vector vectorAlgorithms
    vectorInstances
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
