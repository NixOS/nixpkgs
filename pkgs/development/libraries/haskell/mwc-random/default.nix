{ cabal, HUnit, primitive, QuickCheck, statistics, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, time, vector
}:

cabal.mkDerivation (self: {
  pname = "mwc-random";
  version = "0.13.1.0";
  sha256 = "16g6b1pphr4p36nn5qjj62iwf47rq8kfmpjgfvd35r3cz9qqb8cb";
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
