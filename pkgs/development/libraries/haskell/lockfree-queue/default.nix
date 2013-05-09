{ cabal, abstractDeque, atomicPrimops, HUnit, IORefCAS
, testFramework, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "lockfree-queue";
  version = "0.2.0.2";
  sha256 = "0mb07hx4cllnxv7mz19vvn9zcc5rx0ji5wv80fx0yirgk2qjpgml";
  buildDepends = [ abstractDeque atomicPrimops IORefCAS ];
  testDepends = [
    abstractDeque atomicPrimops HUnit IORefCAS testFramework
    testFrameworkHunit
  ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree-queue/wiki";
    description = "Michael and Scott lock-free queues";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
