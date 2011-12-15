{ cabal, freeglut, mesa, OpenGLRaw }:

cabal.mkDerivation (self: {
  pname = "GLURaw";
  version = "1.1.0.1";
  sha256 = "0n2yazdk98ia9j65n4ac7k0lnyp9cmz51d344x0jsi0xyfckm0mq";
  buildDepends = [ OpenGLRaw ];
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
