{ cabal, doctest, filepath, transformers, transformersCompat }:

cabal.mkDerivation (self: {
  pname = "distributive";
  version = "0.3.2";
  sha256 = "1n2xnjffrbfw736qn9w5fxy4pjl2319yhimkglhbayq85pz51r1h";
  buildDepends = [ transformers transformersCompat ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/distributive/";
    description = "Haskell 98 Distributive functors -- Dual to Traversable";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
