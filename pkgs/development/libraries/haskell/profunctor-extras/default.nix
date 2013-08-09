{ cabal, comonad, profunctors, semigroupoidExtras, semigroupoids
, tagged, transformers
}:

cabal.mkDerivation (self: {
  pname = "profunctor-extras";
  version = "3.3.3.1";
  sha256 = "16naa6ksgwy6fh8vwflcc9s0rpamn886as8qhjqrkpjlc8s83h7g";
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
