{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "bmp";
  version = "1.2.3.2";
  sha256 = "0lr6ys15ap3myzv48xmcy0bv17s4x2drskqz3kmbp06knrx9y1bh";
  buildDepends = [ binary ];
  meta = {
    homepage = "http://code.ouroborus.net/bmp";
    description = "Read and write uncompressed BMP image files";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
