{ cabal, comonad, contravariant, distributive, semigroupoids
, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonad-transformers";
  version = "3.0.2";
  sha256 = "1910hqp7f03p44alxm4dm8i4wikf0b60hmm85yrhbq02kcr3379d";
  buildDepends = [
    comonad contravariant distributive semigroupoids semigroups
    transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/comonad-transformers/";
    description = "Comonad transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
