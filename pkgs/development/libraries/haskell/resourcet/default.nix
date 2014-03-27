{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.4.10.1";
  sha256 = "05skxqxhbmsyjn72w1c9n924d865wxadfsxlavk0nmbd7ygmnazb";
  buildDepends = [
    liftedBase mmorph monadControl mtl transformers transformersBase
  ];
  testDepends = [ hspec liftedBase transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Deterministic allocation and freeing of scarce resources";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
