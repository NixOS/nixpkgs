{ cabal, doctest, hspec, liftedBase, monadControl, QuickCheck
, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.3";
  sha256 = "1jvbm5v25h1m5a9gd0f417mhpabp3kcfzsjm8887gcyimp2d0z07";
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
