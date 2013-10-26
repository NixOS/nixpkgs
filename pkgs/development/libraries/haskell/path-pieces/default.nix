{ cabal, hspec, HUnit, QuickCheck, text, time }:

cabal.mkDerivation (self: {
  pname = "path-pieces";
  version = "0.1.3";
  sha256 = "03x9kfcaz1zsdpdzs05pcl0hv4hffgsl2js8xiy5slba6n841v4l";
  buildDepends = [ text time ];
  testDepends = [ hspec HUnit QuickCheck text ];
  meta = {
    description = "Components of paths";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
