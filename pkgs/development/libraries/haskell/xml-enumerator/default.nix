{ cabal, attoparsecText, attoparsecTextEnumerator, blazeBuilder
, blazeBuilderEnumerator, dataDefault, enumerator, failure, text
, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-enumerator";
  version = "0.4.0";
  sha256 = "1lgsm0xbz1f5941d8l3a9ipmwmffj1b8gp5a8if7r9davjf029xn";
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
