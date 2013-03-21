{ cabal, GLURaw, libX11, mesa, OpenGLRaw }:

cabal.mkDerivation (self: {
  pname = "OpenGL";
  version = "2.8.0.0";
  sha256 = "1wb5772dhh4a81ks9zxz8adpfxa97hcna9s263h9cl2vny6ksxff";
  buildDepends = [ GLURaw OpenGLRaw ];
  extraLibraries = [ libX11 mesa ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Opengl";
    description = "A binding for the OpenGL graphics system";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
