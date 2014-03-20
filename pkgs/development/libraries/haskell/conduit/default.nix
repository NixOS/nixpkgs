{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, QuickCheck
, resourcet, text, textStreamDecode, transformers, transformersBase
, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.16";
  sha256 = "12baxqgbs5wd6w024yrbv47lp320lgacrsb527r7xvbgffji3lbq";
  buildDepends = [
    liftedBase mmorph monadControl mtl resourcet text textStreamDecode
    transformers transformersBase void
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
