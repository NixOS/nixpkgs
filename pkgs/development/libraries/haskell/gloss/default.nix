{ cabal, bmp, GLUT, OpenGL }:

cabal.mkDerivation (self: {
  pname = "gloss";
  version = "1.7.8.1";
  sha256 = "0bi60zprgq1dd6prshvgqyyp13l6n5f171aryxg254kjagvrm3lf";
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
