{ cabal, comonad, dlist, dlistInstances, foldl, hashable, hspec
, QuickCheck, semigroupoids, semigroups, text, transformers
, unorderedContainers, vector, vectorAlgorithms, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.6.0.2";
  sha256 = "1ckdx8szllk4np5samfdx7l6lzarmfabm8w4210b5m7yms2w98sy";
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
