{ cabal, bmp, GLUT, OpenGL }:

cabal.mkDerivation (self: {
  pname = "gloss";
  version = "1.7.8.4";
  sha256 = "06m90n0gxjhfdl2jalwzwsbgdg854bqw1qygkxbcfcknrpd2ampk";
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
