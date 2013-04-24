{ cabal, blazeBuilder, blazeHtml, blazeMarkup, failure, hspec
, HUnit, parsec, shakespeare, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "1.1.7.1";
  sha256 = "1kcjzvslxis8qapy7g1cqkqqamrnkyammy33pan7ckzv5fd59q5p";
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
