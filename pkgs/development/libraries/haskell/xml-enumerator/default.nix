{ cabal, attoparsecText, attoparsecTextEnumerator, blazeBuilder
, blazeBuilderEnumerator, dataDefault, enumerator, failure, text
, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-enumerator";
  version = "0.4.3.2";
  sha256 = "0ahxg81fr4vf5lwbqsbhvpfczhi2fgxb7qrzd38d2zgklrh9vh7v";
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
