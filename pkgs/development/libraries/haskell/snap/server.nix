{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, caseInsensitive, enumerator
, MonadCatchIOTransformers, mtl, network, snapCore, text, time
, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.9.2.4";
  sha256 = "1kwmrlk9dr033h6q05afnr916wnw5wlxrr87z1myv0a6nzqmdhzl";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder blazeBuilderEnumerator
    caseInsensitive enumerator MonadCatchIOTransformers mtl network
    snapCore text time unixCompat
  ];
  jailbreak = true;
  meta = {
    homepage = "http://snapframework.com/";
    description = "A fast, iteratee-based, epoll-enabled web server for the Snap Framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
