{ cabal, doctest, hspec, liftedBase, mmorph, monadControl
, QuickCheck, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.4";
  sha256 = "1y97wc273i3qvq4nqp9kr3bgl8mca257hv92f3lbq2wzqkr5vahk";
  buildDepends = [
    liftedBase mmorph monadControl resourcet text transformers
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
