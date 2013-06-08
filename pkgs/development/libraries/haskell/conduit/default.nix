{ cabal, doctest, hspec, liftedBase, mmorph, monadControl
, QuickCheck, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.6";
  sha256 = "0da5wxhsfjgcn850iimcp15vhg5lw0fa8i7c3hdw4yvrpza14dcn";
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
