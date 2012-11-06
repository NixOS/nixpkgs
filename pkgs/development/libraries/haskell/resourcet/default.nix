{ cabal, liftedBase, monadControl, mtl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.4.1";
  sha256 = "1s9j9nrqnq2qrc3c10cjqxrxajh9qayqzh8j73zwpy5kqkma80sp";
  buildDepends = [
    liftedBase monadControl mtl transformers transformersBase
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Deterministic allocation and freeing of scarce resources";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
