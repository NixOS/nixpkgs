{ cabal, doctest, filepath, transformers, transformersCompat }:

cabal.mkDerivation (self: {
  pname = "distributive";
  version = "0.3";
  sha256 = "0z6vwak2n91vpx9ps9j1pbiw0zlh9jmds84yx1yqssbqx8npi32f";
  buildDepends = [ transformers transformersCompat ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/distributive/";
    description = "Haskell 98 Distributive functors -- Dual to Traversable";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
