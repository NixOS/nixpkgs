{ cabal, aeson, monadControl, persistent, text, transformers }:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.0.0";
  sha256 = "14hg2f0v14m34qvj9m75nn3h4c33bh3gg1xixn0q318hwj9vpfcn";
  buildDepends = [ aeson monadControl persistent text transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
