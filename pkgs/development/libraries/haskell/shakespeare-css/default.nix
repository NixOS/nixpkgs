{ cabal, shakespeare }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.1.0";
  sha256 = "18d0kxfrs0aj9pfd9p1j7w5amch1hvsww3xycgn5qk6i0z7l4ywz";
  buildDepends = [ shakespeare ];
  noHaddock = true;
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into css at compile time. (deprecated)";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
