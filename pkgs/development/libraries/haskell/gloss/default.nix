{ cabal, bmp, GLUT, OpenGL }:

cabal.mkDerivation (self: {
  pname = "gloss";
  version = "1.7.6.4";
  sha256 = "0nyz9iicc6d96yn6yxzwz08g106qb2aadrxlw120wl01aqfw4xis";
  buildDepends = [ bmp GLUT OpenGL ];
  meta = {
    homepage = "http://gloss.ouroborus.net";
    description = "Painless 2D vector graphics, animations and simulations";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
