{ cabal, aeson, hspec, monadControl, persistent, QuickCheck, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.1.2.4";
  sha256 = "0fsqyv5r6h356shmah6bs75fzds0fsmyizbnvj5ywzhc003jv5h9";
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
