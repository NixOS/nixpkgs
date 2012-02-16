{ cabal, bmp, Cabal, GLUT, OpenGL }:

cabal.mkDerivation (self: {
  pname = "gloss";
  version = "1.6.1.1";
  sha256 = "0y0npw27ic23zx7fq7dmvwbz2r62wblw9nbyai9kxgff4m2p3j4m";
  buildDepends = [ bmp Cabal GLUT OpenGL ];
  meta = {
    homepage = "http://gloss.ouroborus.net";
    description = "Painless 2D vector graphics, animations and simulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
