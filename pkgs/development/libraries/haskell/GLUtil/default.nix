{ cabal, cpphs, JuicyPixels, linear, OpenGL, OpenGLRaw, vector }:

cabal.mkDerivation (self: {
  pname = "GLUtil";
  version = "0.7.4";
  sha256 = "0l1w0k3q5g22y90w5frljqh1v4jb7gjzb3scg79zp42pc9v3h4l5";
  buildDepends = [
    cpphs JuicyPixels linear OpenGL OpenGLRaw vector
  ];
  buildTools = [ cpphs ];
  meta = {
    description = "Miscellaneous OpenGL utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
