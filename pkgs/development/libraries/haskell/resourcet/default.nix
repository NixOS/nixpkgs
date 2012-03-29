{ cabal, liftedBase, monadControl, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.3.2";
  sha256 = "0vaygw17cfx2y2lv32lmr7x0vch58dh19jmh8j7mcj11qy5v0nz8";
  buildDepends = [
    liftedBase monadControl transformers transformersBase
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Deterministic allocation and freeing of scarce resources";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
