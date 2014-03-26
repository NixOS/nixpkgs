{ cabal, doctest, filepath, tagged, transformers
, transformersCompat
}:

cabal.mkDerivation (self: {
  pname = "distributive";
  version = "0.4.1";
  sha256 = "0izsgasml3didklkk6z274fzfd1c6qnn0wlzprcz0bnd07zkh814";
  buildDepends = [ tagged transformers transformersCompat ];
  testDepends = [ doctest filepath ];
  meta = {
    homepage = "http://github.com/ekmett/distributive/";
    description = "Haskell 98 Distributive functors -- Dual to Traversable";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
