{cabal, OpenGL, glut, libSM, libICE, libXmu, libXi, mesa}:

cabal.mkDerivation (self : {
  pname = "GLUT";
  version = "2.1.2.1"; # Haskell Platform 2010.1.0.0, 2010.2.0.0, 2011.2.0.0
  sha256 = "0r3js5i468lqlsnvb04iw6gdl81gs3cgqids3xpi4p5qpynbyc02";
  propagatedBuildInputs = [OpenGL glut libSM libICE libXmu libXi mesa];
  meta = {
    description = "A binding for the OpenGL Utility Toolkit";
  };
})

