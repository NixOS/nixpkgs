{ cabal, doctest, filepath, tagged, transformers
, transformersCompat
}:

cabal.mkDerivation (self: {
  pname = "distributive";
  version = "0.4";
  sha256 = "11zln3h7pflv1f6jfma5b505p4wnr9xrs711mhh3a8xi20n4r318";
  buildDepends = [ tagged transformers transformersCompat ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/distributive/";
    description = "Haskell 98 Distributive functors -- Dual to Traversable";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
