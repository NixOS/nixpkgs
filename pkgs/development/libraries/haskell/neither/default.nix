{ cabal, failure, transformers }:

cabal.mkDerivation (self: {
  pname = "neither";
  version = "0.3.0.1";
  sha256 = "1vr8zap3vp28dr48s510lfrbfhw5yz25vng6wyk20582lv4j2mz8";
  buildDepends = [ failure transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/neither";
    description = "Provide versions of Either with good monad and applicative instances. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
