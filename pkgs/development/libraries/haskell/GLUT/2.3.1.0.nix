{ cabal, freeglut, libICE, libSM, libXi, libXmu, mesa, OpenGL
, OpenGLRaw, StateVar, Tensor
}:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.3.1.0";
  sha256 = "1ijx636py7gpm79r0qjsv8f4pw3m1cgz80gnn3qghs3lw0l8f1ci";
  buildDepends = [ OpenGL OpenGLRaw StateVar Tensor ];
  extraLibraries = [ freeglut libICE libSM libXi libXmu mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A binding for the OpenGL Utility Toolkit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
