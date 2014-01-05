{ cabal, async, HUnit, liftedBase, monadControl, mtl, testFramework
, testFrameworkHunit, testFrameworkTh, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-async";
  version = "0.1.0.1";
  sha256 = "03b89cixfin7ksdjh12g0pfrmgzw9mnx6nyvywv3rjc1sra3b8f0";
  buildDepends = [ async liftedBase monadControl transformersBase ];
  testDepends = [
    HUnit liftedBase monadControl mtl testFramework testFrameworkHunit
    testFrameworkTh
  ];
  meta = {
    homepage = "https://github.com/maoe/lifted-async";
    description = "Run lifted IO operations asynchronously and wait for their results";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
