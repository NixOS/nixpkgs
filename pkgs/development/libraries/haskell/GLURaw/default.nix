{ cabal, Cabal, freeglut, mesa, OpenGLRaw }:

cabal.mkDerivation (self: {
  pname = "GLURaw";
  version = "1.2.0.0";
  sha256 = "06dsazj3zadjahwy926gnjngqg8cb1mhdxh8bg5f3axf3hsvxqp1";
  buildDepends = [ Cabal OpenGLRaw ];
  extraLibraries = [ freeglut mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A raw binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
