{ cabal, comonad, hashable, hspec, QuickCheck, semigroupoids
, semigroups, text, transformers, unorderedContainers, vector
, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "mono-traversable";
  version = "0.3.0.3";
  sha256 = "0n8bgynapx43f4agbp596ywnfv0cm12x3ihifr3vzv78iixnl0xh";
  buildDepends = [
    comonad hashable semigroupoids semigroups text transformers
    unorderedContainers vector vectorInstances
  ];
  testDepends = [
    hspec QuickCheck semigroups text transformers unorderedContainers
    vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/mono-traversable";
    description = "Type classes for mapping, folding, and traversing monomorphic containers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
