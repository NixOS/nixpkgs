{ cabal, attempt, Cabal, text, time }:

cabal.mkDerivation (self: {
  pname = "convertible-text";
  version = "0.4.0.2";
  sha256 = "1wqpl9dms1rsd24d00f18l9sm601nm6kr7h4ig8y70jdzy8w73fz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ attempt Cabal text time ];
  meta = {
    homepage = "http://github.com/snoyberg/convertible/tree/text";
    description = "Typeclasses and instances for converting between types (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
