{ cabal, doctest, hspec, liftedBase, monadControl, QuickCheck
, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.2";
  sha256 = "03hyryljvkbgyvwx63qrkvf2wm1qm8640rsm8yb4mahgzp4r130f";
  buildDepends = [
    liftedBase monadControl resourcet text transformers
    transformersBase void
  ];
  testDepends = [
    doctest hspec QuickCheck resourcet text transformers void
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming data processing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
