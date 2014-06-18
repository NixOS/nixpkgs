{ cabal }:

cabal.mkDerivation (self: {
  pname = "BoundedChan";
  version = "1.0.1.0";
  sha256 = "1v4lmp3j8lzk1m2pv5l90j80y0c6yxm6gb1ww9ffsz2jxfzz8vd8";
  meta = {
    description = "Implementation of bounded channels";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
