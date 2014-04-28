{ cabal, doctest, filepath, tagged, transformers
, transformersCompat
}:

cabal.mkDerivation (self: {
  pname = "distributive";
  version = "0.4.3.2";
  sha256 = "16d16ddd5i2pf5q6lkix4g1a1a6l7al6ximwp7jrvifaqcyr5inj";
  buildDepends = [ tagged transformers transformersCompat ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/distributive/";
    description = "Distributive functors -- Dual to Traversable";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
