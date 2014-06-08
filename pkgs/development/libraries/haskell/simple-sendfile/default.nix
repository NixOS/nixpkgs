{ cabal, conduit, conduitExtra, hspec, HUnit, network
, networkConduit, resourcet
}:

cabal.mkDerivation (self: {
  pname = "simple-sendfile";
  version = "0.2.14";
  sha256 = "00k9cachx7y4811b71f8p468kx018hzvpvw6jgf7zmjhc9v922ni";
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
