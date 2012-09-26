{ cabal, blazeBuilder, blazeHtml, blazeMarkup, failure, parsec
, shakespeare, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "1.1.1";
  sha256 = "0003rp40px3zd5j2k8mm6igafbw8npn0zxm3ip27pq506ak2a0p9";
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
