{ cabal, bmp, GLUT, OpenGL }:

cabal.mkDerivation (self: {
  pname = "gloss";
  version = "1.8.0.1";
  sha256 = "17nnmv84pjls1my58yzifbin3pxcnlbpkprglad707rr4lrkkjvv";
  buildDepends = [ bmp GLUT OpenGL ];
  jailbreak = true;
  meta = {
    homepage = "http://gloss.ouroborus.net";
    description = "Painless 2D vector graphics, animations and simulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
