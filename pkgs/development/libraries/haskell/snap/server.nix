{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, caseInsensitive, enumerator
, MonadCatchIOTransformers, mtl, network, snapCore, text, time
, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "snap-server";
  version = "0.9.3.3";
  sha256 = "1n50xyhg4rva7ifv70825177606q87ip7f9p5kf94i9kci0kmlig";
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
