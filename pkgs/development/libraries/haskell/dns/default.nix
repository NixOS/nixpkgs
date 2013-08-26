{ cabal, attoparsec, attoparsecConduit, binary, blazeBuilder
, conduit, hspec, iproute, mtl, network, networkConduit, random
}:

cabal.mkDerivation (self: {
  pname = "dns";
  version = "0.3.8";
  sha256 = "1x2rfm89qpx7dpxr457i2wqmjry8r28f42j194131mfx4gc4mwdq";
  buildDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit iproute
    mtl network networkConduit random
  ];
  testDepends = [
    attoparsec attoparsecConduit binary blazeBuilder conduit hspec
    iproute mtl network networkConduit random
  ];
  testTarget = "spec";
  meta = {
    description = "DNS library in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
