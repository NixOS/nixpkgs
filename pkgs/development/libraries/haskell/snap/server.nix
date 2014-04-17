{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, caseInsensitive, enumerator
, MonadCatchIOTransformers, mtl, network, snapCore, text, time
, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.9.4.3";
  sha256 = "1k2nb6ykj4yany8chjsiwwl4gaadshpdlsj2l5mvn14xz5y192d1";
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
