{ cabal, comonad, semigroupoids, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "profunctors";
  version = "4.0.4";
  sha256 = "1hs6cs6y6zwf0c4jb92wnhp23qaxzw3xy7k07m9z98h8ziyqbqhx";
  buildDepends = [ comonad semigroupoids tagged transformers ];
  meta = {
    homepage = "http://github.com/ekmett/profunctors/";
    description = "Profunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
