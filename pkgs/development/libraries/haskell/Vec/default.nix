{ cabal }:

cabal.mkDerivation (self: {
  pname = "Vec";
  version = "0.9.9";
  sha256 = "1ms6w8003aplcndqglw2gxj0ji4m3jki9ndj5gni24w8dqiy5x47";
  meta = {
    homepage = "http://graphics.cs.ucdavis.edu/~sdillard/Vec";
    description = "Fixed-length lists and low-dimensional linear algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
