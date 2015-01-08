{ cabal, deepseq, hashable, HUnit, QuickCheck, tagged
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "psqueues";
  version = "0.1.1.0";
  sha256 = "1w6i6cl9wfblbg8d06lffh4l5y42li9a27myyvwnzfv86z49s9cb";
  buildDepends = [ deepseq hashable ];
  testDepends = [
    deepseq hashable HUnit QuickCheck tagged testFramework
    testFrameworkHunit testFrameworkQuickcheck2
  ];
  meta = {
    description = "Pure priority search queues";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})

