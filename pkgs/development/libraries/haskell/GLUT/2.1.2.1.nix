{cabal, OpenGL, glut, libSM, libICE, libXmu, libXi, mesa}:

cabal.mkDerivation (self : {
  pname = "GLUT";
  version = "2.1.2.1"; # Haskell Platform 2010.1.0.0
  sha256 = "0230bfacbfb85c126f1fba45fcd8d02f20da9ee19180b5ada698224362d17264";
  propagatedBuildInputs = [OpenGL glut libSM libICE libXmu libXi mesa];
  meta = {
    description = "A binding for the OpenGL Utility Toolkit";
  };
})  

