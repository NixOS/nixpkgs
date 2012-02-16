{ cabal, Cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "funcmp";
  version = "1.5";
  sha256 = "f68807833f39178c99877321f0f335cfde12a5c4b38e6c51f33f8cab94b9e12e";
  buildDepends = [ Cabal filepath ];
  meta = {
    homepage = "http://savannah.nongnu.org/projects/funcmp/";
    description = "Functional MetaPost";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
