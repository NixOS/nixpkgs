{ cabal, async, HUnit, liftedBase, monadControl, mtl, testFramework
, testFrameworkHunit, testFrameworkTh, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "lifted-async";
  version = "0.1.0";
  sha256 = "09ns06qgnwls6zcqsjvr7ykhpr1w12vq49ix4bkqriarl1q3ap7b";
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
