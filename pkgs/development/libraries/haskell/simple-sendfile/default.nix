{ cabal, conduit, conduitExtra, hspec, HUnit, network
, networkConduit, resourcet
}:

cabal.mkDerivation (self: {
  pname = "simple-sendfile";
  version = "0.2.15";
  sha256 = "1fa20h2zcvxwdb5j5a0nnhl38bry1p5ckya1l7lrxx9r2bvjkyj9";
  buildDepends = [ network resourcet ];
  testDepends = [
    conduit conduitExtra hspec HUnit network networkConduit resourcet
  ];
  doCheck = false;
  meta = {
    description = "Cross platform library for the sendfile system call";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
