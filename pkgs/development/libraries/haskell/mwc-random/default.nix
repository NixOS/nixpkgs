{ cabal, HUnit, primitive, QuickCheck, statistics, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, time, vector
}:

cabal.mkDerivation (self: {
  pname = "mwc-random";
  version = "0.13.1.1";
  sha256 = "1hi9ci65m3pjkli0rvx2x4fmp73c9fsmnc1zkpaj4g64ibhhir64";
  buildDepends = [ primitive time vector ];
  testDepends = [
    HUnit QuickCheck statistics testFramework testFrameworkHunit
    testFrameworkQuickcheck2 vector
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/bos/mwc-random";
    description = "Fast, high quality pseudo random number generation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
