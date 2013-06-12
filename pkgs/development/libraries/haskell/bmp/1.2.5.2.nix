{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "bmp";
  version = "1.2.5.2";
  sha256 = "0f88f2ynm1fpzbjijy5fa8blfrdv42h5h28hfjlpd4fp0h96in5x";
  buildDepends = [ binary ];
  jailbreak = true;
  meta = {
    homepage = "http://code.ouroborus.net/bmp";
    description = "Read and write uncompressed BMP image files";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
