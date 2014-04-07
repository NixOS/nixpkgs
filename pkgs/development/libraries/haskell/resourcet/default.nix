{ cabal, exceptions, hspec, liftedBase, mmorph, monadControl, mtl
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "1.1.0.1";
  sha256 = "02w2gz0zn039bz1ig91jd0zkg9w1nxpi3byh6ybdsnbyddwfy376";
  buildDepends = [
    exceptions liftedBase mmorph monadControl mtl transformers
    transformersBase
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
