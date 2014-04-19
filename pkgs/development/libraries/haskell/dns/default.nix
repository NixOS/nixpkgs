{ cabal, attoparsec, attoparsecConduit, binary, blazeBuilder
, conduit, conduitExtra, doctest, hspec, iproute, mtl, network
, random, resourcet
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "1.2.1";
  sha256 = "0xv8mj2x8ijqgi7gnh2shr7ns9qghiczm3lw9n37mxk02zbvw8h0";
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
