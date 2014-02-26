{ cabal, blazeBuilder, blazeHtml, blazeMarkup, failure, hspec
, HUnit, parsec, shakespeare, systemFileio, systemFilepath, text
, time
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "1.1.9";
  sha256 = "194a4qnmpgralhvrv6813qfjjy80919famh824lyl9iryqwsbfkc";
  buildDepends = [
    blazeBuilder blazeHtml blazeMarkup failure parsec shakespeare
    systemFileio systemFilepath text time
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
