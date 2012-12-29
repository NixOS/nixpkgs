{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "bmp";
  version = "1.2.3.4";
  sha256 = "134nfchsw4q1k3kr09i5w8jxbr659as4523gs5m2dch15wrmrhf6";
  buildDepends = [ binary ];
  meta = {
    homepage = "http://code.ouroborus.net/bmp";
    description = "Read and write uncompressed BMP image files";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
