{ cabal, comonad, profunctors, semigroupoidExtras, semigroupoids
, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "profunctor-extras";
  version = "3.3.1";
  sha256 = "0z3lip0mjw0xyf516shdrnkkp9h53wglz6sjjqagpjj2viyqkprb";
  buildDepends = [
    comonad profunctors semigroupoidExtras semigroupoids tagged
    transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/profunctor-extras/";
    description = "Profunctor extras";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
