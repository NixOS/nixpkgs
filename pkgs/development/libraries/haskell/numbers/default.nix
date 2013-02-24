{ cabal, QuickCheck, testFramework, testFrameworkQuickcheck2 }:

cabal.mkDerivation (self: {
  pname = "numbers";
  version = "3000.1.0.1";
  sha256 = "0r2s47nfdxasnp8j7giwpxls9v48f6ld0gc2hg2p7y2ar5xfrcc4";
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/DanBurton/numbers";
    description = "Various number types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
