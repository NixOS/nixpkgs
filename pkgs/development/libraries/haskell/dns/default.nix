{ cabal, attoparsec, attoparsecConduit, binary, blazeBuilder
, conduit, doctest, hspec, iproute, mtl, network, networkConduit
, random
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "1.1.1";
  sha256 = "1vyi0rqddaqpnh87gjracp0j3f7ai18qzr6zl6rjkszw3zfngww9";
  buildDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit iproute
    mtl network networkConduit random
  ];
  testDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit doctest
    hspec iproute mtl network networkConduit random
  ];
  testTarget = "spec";
  meta = {
    description = "DNS library in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
