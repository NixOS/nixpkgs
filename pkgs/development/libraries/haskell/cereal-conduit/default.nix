{ cabal, cereal, conduit, HUnit, mtl, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "cereal-conduit";
  version = "0.7.2.1";
  sha256 = "1qjx5y8hznpanchhjfrmi0r6vmiqsj0lh9x09n563gschs8dfisw";
  buildDepends = [ cereal conduit resourcet transformers ];
  testDepends = [ cereal conduit HUnit mtl resourcet transformers ];
  meta = {
    homepage = "https://github.com/litherum/cereal-conduit";
    description = "Turn Data.Serialize Gets and Puts into Sources, Sinks, and Conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
