{ cabal, bmp, GLUT, OpenGL }:

cabal.mkDerivation (self: {
  pname = "gloss";
  version = "1.7.5.2";
  sha256 = "1lasq106slq57k832pqhaq5wh7hwxn5bzg7rjk95rf3rrq5xb9f5";
  buildDepends = [ bmp GLUT OpenGL ];
  meta = {
    homepage = "http://gloss.ouroborus.net";
    description = "Painless 2D vector graphics, animations and simulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
