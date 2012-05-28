{ cabal, shakespeare, text }:

cabal.mkDerivation (self: {
  pname = "shakespeare-js";
  version = "1.0.0.3";
  sha256 = "00x5xvjlaivl42q75cvbwbh055kgvk9i8s4y3xcmk4h7lnpfyzd6";
  buildDepends = [ shakespeare text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Stick your haskell variables into javascript/coffeescript at compile time";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
