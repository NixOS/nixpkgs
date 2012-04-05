{ cabal, blazeBuilder, blazeHtml, failure, parsec, shakespeare
, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "1.0.1";
  sha256 = "1h3bq9vignnbvnjwr35yf4am0k90l1c21x0phnhnigdx7wanygcz";
  buildDepends = [
    blazeBuilder blazeHtml failure parsec shakespeare text
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "Haml-like template files that are compile-time checked";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
