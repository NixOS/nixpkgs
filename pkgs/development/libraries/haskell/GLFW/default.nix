{ cabal, libX11, mesa, OpenGL }:

cabal.mkDerivation (self: {
  pname = "GLFW";
  version = "0.5.2.0";
  sha256 = "06vps929dmk9yimfv7jj12m0p0bf4ih0ssf6rbcq2j6i9wbhpxq3";
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
