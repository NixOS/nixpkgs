{cabal, binary} :

cabal.mkDerivation (self : {
  pname = "bmp";
  version = "1.1.2.1";
  sha256 = "01w0fbfzdmrfnmnkjkg9paagfkzsjn57rx7lf2npzp95rmljplkb";
  propagatedBuildInputs = [ binary ];
  meta = {
    homepage = "http://code.ouroborus.net/bmp";
    description = "Read and write uncompressed BMP image files.";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
