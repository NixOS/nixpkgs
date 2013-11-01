{ cabal, attoparsec, attoparsecConduit, binary, blazeBuilder
, conduit, doctest, hspec, iproute, mtl, network, networkConduit
, random
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "1.0.0";
  sha256 = "16h7c332qdj77dw8kvrdn1jzhzsnrcybbbm5x7pxvgpnn0wzz8si";
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
