{ cabal, aeson, monadControl, persistent, text, transformers }:

cabal.mkDerivation (self: {
  pname = "persistent-template";
  version = "0.8.1";
  sha256 = "0av1rzqz80lzirk9l45jiwj4zar6ncy0q9x7dqhsrklyxk4jzv6v";
  buildDepends = [ aeson monadControl persistent text transformers ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
