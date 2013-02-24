{ cabal, HUnit, primitive, QuickCheck, statistics, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, time, vector
}:

cabal.mkDerivation (self: {
  pname = "mwc-random";
  version = "0.12.0.1";
  sha256 = "1sq4yxi231ka8rzwsihqziibs7amvl27ycr018wymm3yz36vsy7c";
  buildDepends = [ primitive time vector ];
  testDepends = [
    HUnit QuickCheck statistics testFramework testFrameworkHunit
    testFrameworkQuickcheck2 vector
  ];
  meta = {
    homepage = "https://github.com/bos/mwc-random";
    description = "Fast, high quality pseudo random number generation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
