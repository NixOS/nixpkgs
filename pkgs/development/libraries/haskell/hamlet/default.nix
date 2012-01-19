{ cabal, blazeBuilder, blazeHtml, failure, parsec, shakespeare
, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "0.10.7.1";
  sha256 = "0ll9pp0qnvw903ncpfgrc67jg385jzla3j9l0yfm9qqnn38sqhqv";
  buildDepends = [
    blazeBuilder blazeHtml failure parsec shakespeare text
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/templates";
    description = "Haml-like template files that are compile-time checked";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
