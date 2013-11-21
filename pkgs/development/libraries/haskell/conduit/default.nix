{ cabal, doctest, hspec, liftedBase, mmorph, monadControl, mtl
, QuickCheck, resourcet, text, transformers, transformersBase, void
}:

cabal.mkDerivation (self: {
  pname = "conduit";
  version = "1.0.9.1";
  sha256 = "178g7sf54h63kn6z4k69s13phi73ijdqam72s4dzprdhwnfar517";
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
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
