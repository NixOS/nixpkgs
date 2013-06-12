{ cabal, fileLocation, hspec, HUnit, QuickCheck, text, time }:

cabal.mkDerivation (self: {
  pname = "path-pieces";
  version = "0.1.2";
  sha256 = "1cxsa8lq1f2jf86iv6f17nraiav8k2vzjxln1y7z45qhcp1sbbaa";
  buildDepends = [ text time ];
  testDepends = [ fileLocation hspec HUnit QuickCheck text ];
  meta = {
    description = "Components of paths";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
