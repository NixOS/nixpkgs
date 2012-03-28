{ cabal, freeglut, libICE, libSM, libXi, libXmu, mesa, OpenGL }:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.1.1.2";
  sha256 = "d5ecf4b6bacc5e68ade00710df04fa158c6ed322c74362954716a0baba6bd3fb";
  buildDepends = [ OpenGL ];
  extraLibraries = [ freeglut libICE libSM libXi libXmu mesa ];
  meta = {
    homepage = "http://www.haskell.org/HOpenGL/";
    description = "A binding for the OpenGL Utility Toolkit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
