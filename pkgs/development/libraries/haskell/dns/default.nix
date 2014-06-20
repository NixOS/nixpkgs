{ cabal, attoparsec, binary, blazeBuilder, conduit, conduitExtra
, doctest, hspec, iproute, mtl, network, random, resourcet
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "1.4.0";
  sha256 = "1r004wpq0z98f6n3rqqlkqmb799sdldj5087icksi6rxxr3plrs9";
  buildDepends = [
    attoparsec binary blazeBuilder conduit conduitExtra iproute mtl
    network random resourcet
  ];
  testDepends = [
    attoparsec binary blazeBuilder conduit conduitExtra doctest hspec
    iproute mtl network random resourcet
  ];
  testTarget = "spec";
  meta = {
    description = "DNS library in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
