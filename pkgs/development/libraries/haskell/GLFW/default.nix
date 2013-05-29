{ cabal, libX11, mesa, OpenGL }:

cabal.mkDerivation (self: {
  pname = "GLFW";
  version = "0.5.1.0";
  sha256 = "190d75w84y9gayxvdz13dnzpyflc5qy4vdg5iv9p2dpcamcih3km";
  buildDepends = [ OpenGL ];
  extraLibraries = [ libX11 mesa ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/GLFW";
    description = "A Haskell binding for GLFW";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
