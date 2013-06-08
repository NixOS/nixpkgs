{ cabal, comonad, profunctors, semigroupoidExtras, semigroupoids
, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "profunctor-extras";
  version = "3.3";
  sha256 = "0sdiwc1d2jx2xrzsxjsxjh8m24f4blr2m8vmh78knpi9hy0bxgvr";
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
