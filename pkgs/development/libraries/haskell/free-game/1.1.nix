{ cabal, boundingboxes, colors, controlBool, filepath, free
, freetype2, GLFWB, hashable, JuicyPixels, JuicyPixelsUtil, lens
, linear, mtl, OpenGL, OpenGLRaw, random, reflection, transformers
, vector, void
}:

cabal.mkDerivation (self: {
  pname = "free-game";
  version = "1.1";
  sha256 = "0id3vn2j44gd8krl5icacwxgx00h6r89yncjg10nyyb90rymvxzz";
  buildDepends = [
    boundingboxes colors controlBool filepath free freetype2 GLFWB
    hashable JuicyPixels JuicyPixelsUtil lens linear mtl OpenGL
    OpenGLRaw random reflection transformers vector void
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/fumieval/free-game";
    description = "Create games for free";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
