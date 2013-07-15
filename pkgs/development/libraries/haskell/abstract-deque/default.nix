{ cabal, HUnit, random, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "abstract-deque";
  version = "0.2.2";
  sha256 = "12g4y3j59nkjw9ja247m8ydhj6a033lzfbqkp4a5slrqdxfdlvyb";
  buildDepends = [ HUnit random testFramework testFrameworkHunit ];
  testDepends = [ HUnit random testFramework testFrameworkHunit ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree-queue/wiki";
    description = "Abstract, parameterized interface to mutable Deques";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
