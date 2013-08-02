{ cabal, attoparsec, attoparsecConduit, binary, blazeBuilder
, conduit, hspec, iproute, mtl, network, networkConduit, random
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "0.3.7";
  sha256 = "1wly3h36j9gjyx6p2vzand5019m6rs0qkcf1h4q61igks65xs674";
  buildDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit iproute
    mtl network networkConduit random
  ];
  testDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit hspec
    iproute mtl network networkConduit random
  ];
  doCheck = false;
  meta = {
    description = "DNS library in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
