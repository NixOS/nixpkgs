{ cabal, aeson, hspec, monadControl, monadLogger, persistent
, QuickCheck, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.2.0.6";
  sha256 = "1vkrxf2dabk9z0igfbvb2ib2bxcxi5af2vpxllv74cbjz9r6ip3s";
  buildDepends = [
    aeson monadControl monadLogger persistent text transformers
  ];
  testDepends = [ aeson hspec persistent QuickCheck text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
