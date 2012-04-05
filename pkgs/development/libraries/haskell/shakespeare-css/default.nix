{ cabal, parsec, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-css";
  version = "1.0.1";
  sha256 = "0n7ld8lr73k16gx3q1ab0qgsv6h0j77ma8dm7daisav9hci9sdbs";
  buildDepends = [ parsec shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into css at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
