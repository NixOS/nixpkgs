{ cabal, parsec, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.1.2";
  sha256 = "055nzffn5zlbwilm8624iaqzxchi247rwpca8adbxai1n2ja9fh7";
  buildDepends = [ parsec shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into css at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
