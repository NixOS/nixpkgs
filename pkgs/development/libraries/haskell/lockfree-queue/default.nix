{ cabal, abstractDeque, HUnit, IORefCAS, testFramework
, testFrameworkHunit
}:

cabal.mkDerivation (self: {
  pname = "lockfree-queue";
  version = "0.2";
  sha256 = "0m76wjw13nyj2mpz1dv2crg9sk66nlf62qgk2hbsa7ymydkq797c";
  buildDepends = [ abstractDeque IORefCAS ];
  testDepends = [
    abstractDeque HUnit IORefCAS testFramework testFrameworkHunit
  ];
  meta = {
    homepage = "https://github.com/rrnewton/haskell-lockfree-queue/wiki";
    description = "Michael and Scott lock-free queues";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
