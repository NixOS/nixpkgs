{ cabal, blazeBuilder, blazeHtml, Cabal, failure, parsec
, shakespeare, text
}:

cabal.mkDerivation (self: {
  pname = "hamlet";
  version = "0.10.8";
  sha256 = "1vlp8vwaipz757vnd95gcdi9dkrpbgfdlsb3kgjivsj7rqbmxf7z";
  buildDepends = [
    blazeBuilder blazeHtml Cabal failure parsec shakespeare text
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
