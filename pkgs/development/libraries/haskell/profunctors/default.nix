{ cabal, comonad, semigroupoids, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "profunctors";
  version = "4.0.2";
  sha256 = "1p98pczrxvhk1imwics25b5ac59qzixblns83a1k9zszvz42kmix";
  buildDepends = [ comonad semigroupoids tagged transformers ];
  meta = {
    homepage = "http://github.com/ekmett/profunctors/";
    description = "Profunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
