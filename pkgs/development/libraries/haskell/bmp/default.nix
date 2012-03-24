{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "bmp";
  version = "1.2.0.2";
  sha256 = "0y1fjbhk73dj260wd1jhcf12fkh4maba4iwkzdg2087s9saxvljk";
  buildDepends = [ binary ];
  meta = {
    homepage = "http://code.ouroborus.net/bmp";
    description = "Read and write uncompressed BMP image files";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
