{ cabal, cereal, conduit, HUnit, mtl, resourcet, transformers }:

cabal.mkDerivation (self: {
  pname = "cereal-conduit";
  version = "0.7.2";
  sha256 = "03jlhpz82a7j7n0351db0h7pkxihik3fv0wgjny7i0vlq7gyqdpl";
  buildDepends = [ cereal conduit transformers ];
  testDepends = [ cereal conduit HUnit mtl resourcet transformers ];
  meta = {
    homepage = "https://github.com/litherum/cereal-conduit";
    description = "Turn Data.Serialize Gets and Puts into Sources, Sinks, and Conduits";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
