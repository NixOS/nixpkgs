{ cabal, exceptions, hspec, liftedBase, mmorph, monadControl, mtl
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "1.1.1";
  sha256 = "0v80wlxpcikr41p8wxa2kr184ghp94bgb5fwym9c27k8djig2awy";
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
