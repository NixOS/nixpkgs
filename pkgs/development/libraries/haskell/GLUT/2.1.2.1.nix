{ cabal, freeglut, libICE, libSM, libXi, libXmu, mesa, OpenGL }:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.1.2.1";
  sha256 = "0r3js5i468lqlsnvb04iw6gdl81gs3cgqids3xpi4p5qpynbyc02";
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
