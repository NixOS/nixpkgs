{ cabal, HUnit, primitive, QuickCheck, statistics, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, time, vector
}:

cabal.mkDerivation (self: {
  pname = "mwc-random";
  version = "0.13.1.2";
  sha256 = "0b0amp9nv750azg3jc5yyfpdaqzh0z09jp41hwgrzr0j6kq1ygqi";
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
