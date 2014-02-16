{ cabal, HUnit, stm }:

cabal.mkDerivation (self: {
  pname = "SafeSemaphore";
  version = "0.10.0";
  sha256 = "0zjm99jqkbn99p5d3mdggij4b4jfpz4fk1rwpd48ld4vmzzqh92c";
  buildDepends = [ stm ];
  testDepends = [ HUnit ];
  meta = {
    homepage = "https://github.com/ChrisKuklewicz/SafeSemaphore";
    description = "Much safer replacement for QSemN, QSem, and SampleVar";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
