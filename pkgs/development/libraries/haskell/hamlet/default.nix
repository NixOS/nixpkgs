{ cabal, blazeBuilder, blazeHtml, blazeMarkup, failure, hspec
, HUnit, parsec, shakespeare, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "1.1.7";
  sha256 = "0vx2z8zvlr3860cypa3lkd8q51k6gngw65jqcbik3bxfbjj2qcv3";
  buildDepends = [
    blazeBuilder blazeHtml blazeMarkup failure parsec shakespeare text
  ];
  testDepends = [ blazeHtml blazeMarkup hspec HUnit parsec text ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Haml-like template files that are compile-time checked";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
