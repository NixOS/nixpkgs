{ cabal, bmp, GLUT, OpenGL }:

cabal.mkDerivation (self: {
  pname = "gloss";
  version = "1.7.8.3";
  sha256 = "0wbp8bz5c3hzix6r7nbg6dmakb77i3lq4hgjk3gd8mvksd3n97jr";
  buildDepends = [ bmp GLUT OpenGL ];
  meta = {
    homepage = "http://gloss.ouroborus.net";
    description = "Painless 2D vector graphics, animations and simulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
