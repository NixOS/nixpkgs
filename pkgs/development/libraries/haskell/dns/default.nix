{ cabal, attoparsec, attoparsecConduit, binary, blazeBuilder
, conduit, conduitExtra, doctest, hspec, iproute, mtl, network
, random, resourcet
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "1.2.2";
  sha256 = "0xba8bwxn5n3bh1qfbrmnrfsnf20iwa10acx1z4017jbnx0s025v";
  buildDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit
    conduitExtra iproute mtl network random resourcet
  ];
  testDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit
    conduitExtra doctest hspec iproute mtl network random resourcet
  ];
  testTarget = "spec";
  meta = {
    description = "DNS library in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
