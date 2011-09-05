{ cabal, freeglut, OpenGLRaw }:

cabal.mkDerivation (self: {
  pname = "GLURaw";
  version = "1.1.0.0";
  sha256 = "03lsskqxh2q7kbnw8hbxz5wp7zq55nwbibsb9maj4y3xpc1vprac";
  buildDepends = [ OpenGLRaw ];
  extraLibraries = [ freeglut ];
  meta = {
    homepage = "http://www.haskell.org/HOpenGL/";
    description = "A raw binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
