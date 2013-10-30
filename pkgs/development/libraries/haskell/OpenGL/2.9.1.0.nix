{ cabal, GLURaw, libX11, mesa, OpenGLRaw, text }:

cabal.mkDerivation (self: {
  pname = "OpenGL";
  version = "2.9.1.0";
  sha256 = "09xzjaa9qyh7bfsnq226v9zi6lhnalhmlqlca3808hgax8ijwhp3";
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
