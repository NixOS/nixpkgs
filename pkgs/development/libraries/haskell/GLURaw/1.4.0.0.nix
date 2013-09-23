{ cabal, freeglut, mesa, OpenGLRaw }:

cabal.mkDerivation (self: {
  pname = "GLURaw";
  version = "1.4.0.0";
  sha256 = "0q86rpd5cx0vrb9d3y1fljc3mg0p8wy6xdn37ngv2s0f4kslq63g";
  buildDepends = [ OpenGLRaw ];
  extraLibraries = [ freeglut mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A raw binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
