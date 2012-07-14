{ cabal, liftedBase, monadControl, mtl, transformers
, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "resourcet";
  version = "0.3.3.1";
  sha256 = "164r2p08j3im4wz5jkadl5pvb0qj02k4f2s3v08lm39a51kygjdl";
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
