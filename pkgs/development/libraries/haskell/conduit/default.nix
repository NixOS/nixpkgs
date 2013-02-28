{ cabal, doctest, hspec, liftedBase, monadControl, QuickCheck
, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.0.2";
  sha256 = "0dl73wjdbprrv6ll94x4ck0b561n43y3a7764s065zbsm8mn8h3z";
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
