{ cabal, profunctors }:

cabal.mkDerivation (self: {
  pname = "profunctor-extras";
  version = "4.0";
  sha256 = "10j458liqlyz5s9gkg95c6aq7ap5fa7d8pc7hygy71nn87pm2g4a";
  buildDepends = [ profunctors ];
  meta = {
    homepage = "http://github.com/ekmett/profunctor-extras/";
    description = "This package has been absorbed into profunctors 4.0";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
