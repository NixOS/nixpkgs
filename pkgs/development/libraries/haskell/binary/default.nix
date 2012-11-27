{ cabal }:

cabal.mkDerivation (self: {
  pname = "binary";
  version = "0.6.4.0";
  sha256 = "0vq80fzhwil5bx4a2vbd3jvfh1awhg1pwxgvq3lvbi37yzl0ydgh";
  meta = {
    homepage = "https://github.com/kolmodin/binary";
    description = "Binary serialisation for Haskell values using lazy ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
