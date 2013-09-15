{ cabal, HUnit, primitive, QuickCheck, statistics, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, time, vector
}:

cabal.mkDerivation (self: {
  pname = "mwc-random";
  version = "0.13.0.0";
  sha256 = "16f8dd81wj81h0jcqnrlr2d6mjc7q2r436qf8z320d6wpzih2djy";
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
