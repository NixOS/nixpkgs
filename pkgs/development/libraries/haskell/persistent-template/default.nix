{ cabal, aeson, monadControl, persistent, text, transformers }:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "1.1.2.2";
  sha256 = "168cxlnpcgkm7m7kzl3zlcvpgdl9wz7vx3anw8z8pc50qjns8dy0";
  buildDepends = [ aeson monadControl persistent text transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
