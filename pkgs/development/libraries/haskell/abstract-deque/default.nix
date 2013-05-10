{ cabal, HUnit, random, testFramework, testFrameworkHunit }:

cabal.mkDerivation (self: {
  pname = "abstract-deque";
  version = "0.2";
  sha256 = "0cq1k74b854flfvh7qhfnpngn4vyzp1az1rkaara23wlylydgs89";
  buildDepends = [ HUnit random ];
  testDepends = [ HUnit random testFramework testFrameworkHunit ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree-queue/wiki";
    description = "Abstract, parameterized interface to mutable Deques";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
