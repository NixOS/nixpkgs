{cabal, QuickCheck} :

cabal.mkDerivation (self : {
  pname = "datetime";
  version = "0.2.1";
  sha256 = "1yfg3wvi13r725dhfsmcdw4ns3cgl2ayrb5jck0q8b4crk2dlrzg";
  propagatedBuildInputs = [ QuickCheck ];
  meta = {
    homepage = "http://github.com/esessoms/datetime";
    description = "Utilities to make Data.Time.* easier to use.";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
