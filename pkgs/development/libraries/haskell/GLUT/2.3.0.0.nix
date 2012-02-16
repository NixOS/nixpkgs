{ cabal, Cabal, freeglut, libICE, libSM, libXi, libXmu, mesa
, OpenGL, OpenGLRaw, StateVar, Tensor
}:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.3.0.0";
  sha256 = "10rh57w3lx8fs0xy24lqilv5a5sgq57kshydja41r6fq9wdvwp99";
  buildDepends = [ Cabal OpenGL OpenGLRaw StateVar Tensor ];
  extraLibraries = [ freeglut libICE libSM libXi libXmu mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A binding for the OpenGL Utility Toolkit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
