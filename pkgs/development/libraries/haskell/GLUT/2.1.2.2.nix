{ cabal, freeglut, libICE, libSM, libXi, libXmu, mesa, OpenGL }:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.1.2.2";
  sha256 = "14g2ykcczy1hhpgflxv158zx2izkl1p0wj1x0am1grkkj1n9jbwi";
  buildDepends = [ OpenGL ];
  extraLibraries = [ freeglut libICE libSM libXi libXmu mesa ];
  noHaddock = true;
  meta = {
    homepage = "http://www.haskell.org/HOpenGL/";
    description = "A binding for the OpenGL Utility Toolkit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
