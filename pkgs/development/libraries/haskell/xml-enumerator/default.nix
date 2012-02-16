{ cabal, attoparsec, attoparsecEnumerator, blazeBuilder
, blazeBuilderEnumerator, Cabal, dataDefault, enumerator, failure
, text, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-enumerator";
  version = "0.4.4.1";
  sha256 = "0vwn6s7x626970b8lgyhmngkqv5n5kvv0qikrvi9sjzq5rjyx1zj";
  buildDepends = [
    attoparsec attoparsecEnumerator blazeBuilder blazeBuilderEnumerator
    Cabal dataDefault enumerator failure text transformers xmlTypes
  ];
  meta = {
    homepage = "http://github.com/snoyberg/xml";
    description = "Pure-Haskell utilities for dealing with XML with the enumerator package. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
