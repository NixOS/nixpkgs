{ cabal, comonad, comonadTransformers, mtl, semigroups
, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonads-fd";
  version = "3.0";
  sha256 = "1j5ymj711c49fsk2ilxfpzqr0jr117z8kb5ggyh5nlwjy16m32in";
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
