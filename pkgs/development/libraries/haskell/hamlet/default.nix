{ cabal, blazeBuilder, blazeHtml, blazeMarkup, failure, parsec
, shakespeare, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "1.1.6.2";
  sha256 = "00asrmyb4k9xpsbwwafm3rj1lisssrc3hj3dsr827w9x86xxargy";
  buildDepends = [
    blazeBuilder blazeHtml blazeMarkup failure parsec shakespeare text
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Haml-like template files that are compile-time checked";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
