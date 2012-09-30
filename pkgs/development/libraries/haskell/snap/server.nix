{ cabal, attoparsec, attoparsecEnumerator, binary, blazeBuilder
, blazeBuilderEnumerator, caseInsensitive, directoryTree
, enumerator, filepath, MonadCatchIOTransformers, mtl, network
, snapCore, text, time, transformers, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.9.2.3";
  sha256 = "0wl7clzwrd34d32sikd6vkj3pla9yni26mmdsnrjw1s3lq412yqd";
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
