{ cabal, aeson, monadControl, persistent, text, transformers }:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "0.9.0";
  sha256 = "17rcmqmakpqk2d630rpj6i345jc7hk225c26s5v8ks3hds4dn85w";
  buildDepends = [ aeson monadControl persistent text transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
