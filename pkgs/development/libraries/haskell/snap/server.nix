{ cabal, attoparsec, attoparsecEnumerator, binary, blazeBuilder
, blazeBuilderEnumerator, caseInsensitive, directoryTree
, enumerator, filepath, MonadCatchIOTransformers, mtl, network
, snapCore, text, time, transformers, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.9.2.2";
  sha256 = "1yfm09w1zybdsbn1rj9gdbrbh63lhmrykyg9rc2ys7fcaszvsx7c";
  buildDepends = [
    attoparsec attoparsecEnumerator binary blazeBuilder
    blazeBuilderEnumerator caseInsensitive directoryTree enumerator
    filepath MonadCatchIOTransformers mtl network snapCore text time
    transformers unixCompat
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
