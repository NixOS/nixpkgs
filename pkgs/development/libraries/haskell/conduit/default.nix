{ cabal, hspec, liftedBase, mmorph, monadControl, mtl, QuickCheck
, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.13.1";
  sha256 = "0kxfck6d72fdnymf2rj6m7h97svq1d2fq1ss5mlhsrks5fflia9y";
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
