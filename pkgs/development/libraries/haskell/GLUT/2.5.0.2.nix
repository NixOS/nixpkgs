{ cabal, freeglut, libICE, libSM, libXi, libXmu, mesa, OpenGL
, OpenGLRaw
}:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.5.0.2";
  sha256 = "0v6lwxn9karmym4fzd0hramcj86sb4wgiyqn47hmcg1dd1fsnhb5";
  buildDepends = [ OpenGL OpenGLRaw ];
  extraLibraries = [ freeglut libICE libSM libXi libXmu mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A binding for the OpenGL Utility Toolkit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
