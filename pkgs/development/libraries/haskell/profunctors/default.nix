{ cabal, comonad, semigroupoids, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "profunctors";
  version = "4.0.1";
  sha256 = "13yr3n7jkhxbk4gk6nd1j8p1a7g5ir8g9xprcy3s1x39cqf4m986";
  buildDepends = [ comonad semigroupoids tagged transformers ];
  meta = {
    homepage = "http://github.com/ekmett/profunctors/";
    description = "Profunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
