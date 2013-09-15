{ cabal, cereal, conduit, HUnit, mtl, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "cereal-conduit";
  version = "0.7.1";
  sha256 = "0ry6vc3nkb1lj0p103b8pyd3472hx62s3c7yw3fk8mbjlygxyv43";
  buildDepends = [ cereal conduit transformers ];
  testDepends = [ cereal conduit HUnit mtl resourcet transformers ];
  meta = {
    homepage = "https://github.com/litherum/cereal-conduit";
    description = "Turn Data.Serialize Gets and Puts into Sources, Sinks, and Conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
