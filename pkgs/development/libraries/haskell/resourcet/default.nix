{ cabal, liftedBase, monadControl, mtl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.4.2";
  sha256 = "18s6q35vl7qxvrawcnqiy8yw46b97yl9fs2s9anmnwm6qqyc8pwl";
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
