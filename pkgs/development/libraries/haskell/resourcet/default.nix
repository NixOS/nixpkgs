{ cabal, hspec, liftedBase, monadControl, mtl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.4.5";
  sha256 = "1i2n0y4ridlzi2fn319f8jg1whb10gajgyvbz0rx2mwxj15bbgni";
  buildDepends = [
    liftedBase monadControl mtl transformers transformersBase
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
