{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "distributive";
  version = "0.2.2";
  sha256 = "13wvr2wb3h2nr1qd3dwjqx0b6g4igjqm3q2cyi4mc41gwihkbhr2";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://github.com/ekmett/distributive/";
    description = "Haskell 98 Distributive functors -- Dual to Traversable";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
