{ cabal, freeglut, libICE, libSM, libXi, libXmu, mesa, OpenGL
, OpenGLRaw, StateVar, Tensor, fetchurl
}:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.3.0.0";
  sha256 = "10rh57w3lx8fs0xy24lqilv5a5sgq57kshydja41r6fq9wdvwp99";
  buildDepends = [ OpenGL OpenGLRaw StateVar Tensor ];
  extraLibraries = [ freeglut libICE libSM libXi libXmu mesa ];
  patches = [
    (fetchurl { url = "https://github.com/haskell-opengl/GLUT/commit/e962ebb7bed7e61e4591ae67f86199d557c7d54c.patch"; sha256 = "0s9xrkz1pkbkhsjzwbj4ayynmvzp5cckkl2lrizcjwcnqv83srmq"; })
    (fetchurl { url = "https://github.com/haskell-opengl/GLUT/commit/fced812bc726c208064a2c48e411f4d609444abc.patch"; sha256 = "1kc7ic70lq43v8ikbcgbs5f2l4wzaz9vylhkmp38q26zs6qzbv07"; })
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A binding for the OpenGL Utility Toolkit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
