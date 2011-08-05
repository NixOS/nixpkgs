{cabal}:

cabal.mkDerivation (self : {
  pname = "funcmp";
  version = "1.5";
  sha256 = "f68807833f39178c99877321f0f335cfde12a5c4b38e6c51f33f8cab94b9e12e";
  propagatedBuildInputs = [];
  meta = {
    homepage = "http://savannah.nongnu.org/projects/funcmp/";
    description = "Functional MetaPost";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [self.stdenv.lib.maintainers.simons];
  };
})

