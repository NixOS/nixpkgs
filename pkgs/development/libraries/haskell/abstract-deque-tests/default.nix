{ cabal, abstractDeque, HUnit, random, testFramework
, testFrameworkHunit, time
}:

cabal.mkDerivation (self: {
  pname = "abstract-deque-tests";
  version = "0.3";
  sha256 = "19gb5x5z3nvazdra3skm24c2g2byj0i4cjbzfwfghnb5q96gn5sz";
  buildDepends = [
    abstractDeque HUnit random testFramework testFrameworkHunit time
  ];
  testDepends = [
    abstractDeque HUnit random testFramework testFrameworkHunit time
  ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree/wiki";
    description = "A test-suite for any queue or double-ended queue satisfying an interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
