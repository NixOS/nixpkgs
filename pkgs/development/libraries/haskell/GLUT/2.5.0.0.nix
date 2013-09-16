{ cabal, freeglut, libICE, libSM, libXi, libXmu, mesa, OpenGL
, OpenGLRaw
}:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.5.0.0";
  sha256 = "1r5kz9pgg2yn8g4bz3rxrcc74jyrxvg1lmza11jzdgx4v26pg9iz";
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
