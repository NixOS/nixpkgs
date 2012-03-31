{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "bmp";
  version = "1.2.1.1";
  sha256 = "0s5srqkaccrwh9gsxn9kmyh4jf0qf40ix8ipi0b70fbbffr97hmk";
  buildDepends = [ binary ];
  meta = {
    homepage = "http://code.ouroborus.net/bmp";
    description = "Read and write uncompressed BMP image files";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
