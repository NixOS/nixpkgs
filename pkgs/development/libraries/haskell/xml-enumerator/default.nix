{ cabal, attoparsecText, attoparsecTextEnumerator, blazeBuilder
, blazeBuilderEnumerator, dataDefault, enumerator, failure, text
, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-enumerator";
  version = "0.4.1";
  sha256 = "081avccvkakcbf2m22xdda63jhwykqxxclmlhj6msawkyyqniadj";
  buildDepends = [
    attoparsecText attoparsecTextEnumerator blazeBuilder
    blazeBuilderEnumerator dataDefault enumerator failure text
    transformers xmlTypes
  ];
  meta = {
    homepage = "http://github.com/snoyberg/xml";
    description = "Pure-Haskell utilities for dealing with XML with the enumerator package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
