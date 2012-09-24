{ cabal, aeson, monadControl, persistent, text, transformers }:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.0.0.2";
  sha256 = "0skd1gfrxq8mpa2g56b2wn83zw4zca5q2dxyjf6d7k6sh9sc9iz8";
  buildDepends = [ aeson monadControl persistent text transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
