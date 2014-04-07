{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, caseInsensitive, enumerator
, MonadCatchIOTransformers, mtl, network, snapCore, text, time
, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.9.4.2";
  sha256 = "05na8gqbqy0nznasaxfkp4hr7h0s6ypm8000mhn50d27v8nk526m";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder blazeBuilderEnumerator
    caseInsensitive enumerator MonadCatchIOTransformers mtl network
    snapCore text time unixCompat
  ];
  meta = {
    homepage = "http://snapframework.com/";
    description = "A fast, iteratee-based, epoll-enabled web server for the Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
