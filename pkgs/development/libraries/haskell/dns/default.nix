{ cabal, attoparsec, binary, blazeBuilder, conduit, conduitExtra
, doctest, hspec, iproute, mtl, network, random, resourcet
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "1.3.0";
  sha256 = "1zd639d69ha3g1yz7ssvwarwiwyi975ps4i5y8vrarcq2jnnsb6n";
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
