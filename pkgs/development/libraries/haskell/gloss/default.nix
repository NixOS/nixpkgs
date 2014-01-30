{ cabal, bmp, GLUT, OpenGL }:

cabal.mkDerivation (self: {
  pname = "gloss";
  version = "1.8.1.2";
  sha256 = "1ky1gckvyww855dy3fzllf1ixbmc3jpdvz85hx719pcygy7qh71m";
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
