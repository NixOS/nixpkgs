{ cabal, QuickCheck, time }:

cabal.mkDerivation (self: {
  pname = "datetime";
  version = "0.2.1";
  sha256 = "1yfg3wvi13r725dhfsmcdw4ns3cgl2ayrb5jck0q8b4crk2dlrzg";
  buildDepends = [ QuickCheck time ];
  meta = {
    homepage = "http://github.com/esessoms/datetime";
    description = "Utilities to make Data.Time.* easier to use";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
