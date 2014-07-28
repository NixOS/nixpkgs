{ cabal, cpphs, JuicyPixels, linear, OpenGL, OpenGLRaw
, transformers, vector
}:

cabal.mkDerivation (self: {
  pname = "GLUtil";
  version = "0.7.5";
  sha256 = "1rbnq1nrs2b06ph60lh0yvygk82vvnm8c4d0anhjrqw9i58nd3iz";
  buildDepends = [
    cpphs JuicyPixels linear OpenGL OpenGLRaw transformers vector
  ];
  buildTools = [ cpphs ];
  meta = {
    description = "Miscellaneous OpenGL utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
