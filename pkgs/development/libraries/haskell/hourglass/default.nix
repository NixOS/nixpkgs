{ cabal, deepseq, HUnit, mtl, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, time
}:

cabal.mkDerivation (self: {
  pname = "hourglass";
  version = "0.1.1";
  sha256 = "1mxi98l9nsnddkkd35r70l1y04wq0lh6xsapjbkz411q5045wfk7";
  buildDepends = [ deepseq ];
  testDepends = [
    deepseq HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 time
  ];
  meta = {
    homepage = "https://github.com/vincenthz/hs-hourglass";
    description = "simple performant time related library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
