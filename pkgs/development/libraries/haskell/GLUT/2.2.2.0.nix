{ cabal, freeglut, libICE, libSM, libXi, libXmu, mesa, OpenGL
, StateVar, Tensor
}:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.2.2.0";
  sha256 = "0hilpjwkjvpz4sz0zqa36vmx8m1yycjnqdd721mqns7lib2fnzrx";
  buildDepends = [ OpenGL StateVar Tensor ];
  extraLibraries = [ freeglut libICE libSM libXi libXmu mesa ];
  meta = {
    homepage = "http://www.haskell.org/HOpenGL/";
    description = "A binding for the OpenGL Utility Toolkit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
