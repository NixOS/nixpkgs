{ cabal, blazeBuilder, blazeHtml, blazeMarkup, failure, parsec
, shakespeare, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "1.1.6.1";
  sha256 = "15jqlfb7l49xqd2szzjhffbnxs7azq85a759bbwx3jfxdz89cv0k";
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
