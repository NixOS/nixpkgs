{ cabal, attoparsec, attoparsecConduit, binary, blazeBuilder
, conduit, conduitExtra, doctest, hspec, iproute, mtl, network
, random, resourcet
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "1.2.3";
  sha256 = "0h03zh75yzrx08p99ll123qd9a7a2ccj9gad1f8y3340dz3pa7ld";
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
