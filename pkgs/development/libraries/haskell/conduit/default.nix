{ cabal, doctest, hspec, liftedBase, mmorph, monadControl, mtl
, QuickCheck, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.7";
  sha256 = "0nail476sz4dmr052sl5s14hkk336zp22hpgmr2qf141zzy8i2m1";
  buildDepends = [
    liftedBase mmorph monadControl mtl resourcet text transformers
    transformersBase void
  ];
  testDepends = [
    doctest hspec mtl QuickCheck resourcet text transformers void
  ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Streaming data processing library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
