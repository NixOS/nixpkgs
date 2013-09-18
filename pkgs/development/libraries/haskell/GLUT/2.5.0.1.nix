{ cabal, freeglut, libICE, libSM, libXi, libXmu, mesa, OpenGL
, OpenGLRaw
}:

cabal.mkDerivation (self: {
  pname = "GLUT";
  version = "2.5.0.1";
  sha256 = "0f0bz64j7fxa0np8w53n51ri5m0pkwyc1kv7pvdnx02h181gl6l0";
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
