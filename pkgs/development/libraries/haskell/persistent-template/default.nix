{ cabal, aeson, hspec, monadControl, persistent, QuickCheck, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.1.2.5";
  sha256 = "142b02ini1b5c566rzhykv45n4byzvhp9r6yyavy4zyvgdj7ligj";
  buildDepends = [ aeson monadControl persistent text transformers ];
  testDepends = [ aeson hspec persistent QuickCheck text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
