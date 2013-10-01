{ cabal, GLURaw, libX11, mesa, OpenGLRaw, text }:

cabal.mkDerivation (self: {
  pname = "OpenGL";
  version = "2.9.0.0";
  sha256 = "0likrpzlzis8fk11g7mjn102y6y6k2w8bkybqqhhmfls7ccgpvhp";
  buildDepends = [ GLURaw OpenGLRaw text ];
  extraLibraries = [ libX11 mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
