{ cabal, boundingboxes, colors, controlBool, filepath, free
, freetype2, GLFWB, hashable, JuicyPixels, JuicyPixelsUtil, lens
, linear, mtl, OpenGL, OpenGLRaw, random, reflection, transformers
, vector, void
}:

cabal.mkDerivation (self: {
  pname = "free-game";
  version = "1.0.5";
  sha256 = "048hmb4zbn67ycdwy7alhfakdyv405ck79bzrxv2ra6w1v5b3yvf";
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
