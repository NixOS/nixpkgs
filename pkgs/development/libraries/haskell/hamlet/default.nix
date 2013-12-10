{ cabal, blazeBuilder, blazeHtml, blazeMarkup, failure, hspec
, HUnit, parsec, shakespeare, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "1.1.7.5";
  sha256 = "1ph92n5l63qr5hpjcvl37j1w857dwwzzgsxn8mdadi2pz35lxm82";
  buildDepends = [
    blazeBuilder blazeHtml blazeMarkup failure parsec shakespeare text
  ];
  testDepends = [ blazeHtml blazeMarkup hspec HUnit parsec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Haml-like template files that are compile-time checked";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
