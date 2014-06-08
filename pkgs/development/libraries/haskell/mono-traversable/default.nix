{ cabal, comonad, dlist, dlistInstances, foldl, hashable, hspec
, QuickCheck, semigroupoids, semigroups, text, transformers
, unorderedContainers, vector, vectorAlgorithms, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.6.0";
  sha256 = "1ibf7iz24ic2vz0dvmbn5w06vz73g05ipl2q8f93a6zlkqysrkm4";
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
