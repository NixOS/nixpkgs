{ cabal, freeglut, libICE, libSM, libXi, libXmu, mesa, OpenGL
, OpenGLRaw
}:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.5.1.0";
  sha256 = "0zxj5i8rw402gpns5ivb1g5fkk502jwzrkviqhwhrxn7yxrybi1s";
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
