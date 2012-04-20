{ cabal, bmp, GLUT, OpenGL }:

cabal.mkDerivation (self: {
  pname = "gloss";
  version = "1.7.3.1";
  sha256 = "0vylil8jsj7mb14dijrx2ylmsgs1ma3rh2nmiaakr5cmpp4xshf0";
  buildDepends = [ bmp GLUT OpenGL ];
  meta = {
    homepage = "http://gloss.ouroborus.net";
    description = "Painless 2D vector graphics, animations and simulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
