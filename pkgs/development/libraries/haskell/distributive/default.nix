{ cabal, doctest, filepath, tagged, transformers
, transformersCompat
}:

cabal.mkDerivation (self: {
  pname = "distributive";
  version = "0.4.3.1";
  sha256 = "17ny7nlxg6x08f88dyl15wsdhgi0cgafxdsl5wdw5vv6y0jsrx27";
  buildDepends = [ tagged transformers transformersCompat ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/distributive/";
    description = "Distributive functors -- Dual to Traversable";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
