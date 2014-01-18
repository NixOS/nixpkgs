{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, QuickCheck
, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.10";
  sha256 = "12vqh747rdldw3n42cxzd77rzb66129dc690n23q5xy7pbhzilfp";
  buildDepends = [
    liftedBase mmorph monadControl mtl resourcet text transformers
    transformersBase void
  ];
  testDepends = [
    hspec mtl QuickCheck resourcet text transformers void
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming data processing library";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
