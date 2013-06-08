{ cabal, QuickCheck, testFramework, testFrameworkQuickcheck2 }:

cabal.mkDerivation (self: {
  pname = "numbers";
  version = "3000.1.0.3";
  sha256 = "0w2m2m3vp3lpvnc7wkw6pqfz741a68dma4s0asl7cryykwf94xgz";
  testDepends = [
    QuickCheck testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/DanBurton/numbers#readme";
    description = "Various number types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
