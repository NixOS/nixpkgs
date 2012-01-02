{ cabal, blazeBuilder, blazeHtml, failure, parsec, shakespeare
, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "0.10.6";
  sha256 = "0ai00jwbq5nnrgcfhz3sxm2jm2jvz7qbj56lr0wlc3z818a22ams";
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
