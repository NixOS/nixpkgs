{ cabal, sqlite, blazeHtml, enumerator, monadControl, parsec, pool
, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.5.1";
  sha256 = "1m0558vi99z15q0w62a9rkz25n8djswggbad9m0il359jb3mrzsd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml enumerator monadControl parsec pool text time
    transformers
  ];
  extraLibraries = [ sqlite ];
  meta = {
    homepage = "http://docs.yesodweb.com/book/persistent";
    description = "Type-safe, non-relational, multi-backend persistence.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
