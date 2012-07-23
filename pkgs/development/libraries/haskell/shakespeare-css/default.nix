{ cabal, parsec, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.1.3";
  sha256 = "1jj609fcp14b7nzjzsiiy0apbdmap2wi7vlyzdhadirjskxvsvc1";
  buildDepends = [ parsec shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into css at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
