{cabal, continuedFractions, converge, vector} :

cabal.mkDerivation (self : {
  pname = "gamma";
  version = "0.7.0.1";
  sha256 = "0728b5mrzmj9hkaqvikl45jyi2p9hnkl2p6l9yv7wnw557yb0gb2";
  propagatedBuildInputs = [ continuedFractions converge vector ];
  meta = {
    homepage = "https://github.com/mokus0/gamma";
    description = "Gamma function and related functions.";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
