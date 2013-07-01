{ cabal, comonad, comonadTransformers, mtl, semigroups
, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonads-fd";
  version = "3.0.2";
  sha256 = "1gzgld895b11j556nc5pj7nbafx746b1z49bx4z38l9wq6qzbvqa";
  buildDepends = [
    comonad comonadTransformers mtl semigroups transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/comonads-fd/";
    description = "Comonad transformers using functional dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
