{ cabal, hashable, monadControl, stm, time, transformers
, transformersBase, vector
}:

cabal.mkDerivation (self: {
  pname = "resource-pool";
  version = "0.2.1.0";
  sha256 = "12akfi906l1nm7h3wvjkzl9bxn74dbv17xw2c1mqgl6sg470d587";
  buildDepends = [
    hashable monadControl stm time transformers transformersBase vector
  ];
  meta = {
    homepage = "http://github.com/bos/pool";
    description = "A high-performance striped resource pooling implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
