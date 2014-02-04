{ cabal, HUnit, random, testFramework, testFrameworkHunit, time }:

cabal.mkDerivation (self: {
  pname = "abstract-deque";
  version = "0.2.2.1";
  sha256 = "0saf7j8fdqqk9msxrfja22zx8v0ibzrqx3v9l07g5n84yh4ydbdx";
  buildDepends = [
    HUnit random testFramework testFrameworkHunit time
  ];
  testDepends = [
    HUnit random testFramework testFrameworkHunit time
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree-queue/wiki";
    description = "Abstract, parameterized interface to mutable Deques";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
