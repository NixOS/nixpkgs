{ cabal, mtl, random }:

cabal.mkDerivation (self: {
  pname = "MonadRandom";
  version = "0.1.7";
  sha256 = "0y4fsb3j0babq388rw3y1kbxbjz6plfgbg4g1y27hdf7jf5c8x33";
  buildDepends = [ mtl random ];
  meta = {
    description = "Random-number generation monad";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
