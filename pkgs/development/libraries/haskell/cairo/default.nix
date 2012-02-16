{ cabal, Cabal, cairo, gtk2hsBuildtools, libc, mtl, pkgconfig, zlib
}:

cabal.mkDerivation (self: {
  pname = "cairo";
  version = "0.12.2";
  sha256 = "1sa0xfx14y4imq3bd9l0rqrmxls3l9yga249a31zfhcinnr1j9db";
  buildDepends = [ Cabal mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ cairo libc pkgconfig zlib ];
  pkgconfigDepends = [ cairo ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the Cairo library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
