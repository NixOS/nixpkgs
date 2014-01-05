{ cabal, HUnit, mtl, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "digestive-functors";
  version = "0.6.2.0";
  sha256 = "1d07ws5s34x9sviq7mfkl6fh1rl28r5x1rmgbkcxil5h6gxn5mi7";
  buildDepends = [ mtl text time ];
  testDepends = [
    HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text time
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/jaspervdj/digestive-functors";
    description = "A practical formlet library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
