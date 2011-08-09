{cabal, attoparsecText, attoparsecTextEnumerator, blazeBuilder,
 blazeBuilderEnumerator, enumerator, failure, text, transformers,
 xmlTypes} :

cabal.mkDerivation (self : {
  pname = "xml-enumerator";
  version = "0.3.4";
  sha256 = "0sfscsfcfmx56sdxc0wn2j1pyqjd9w92igz1n9xaph7zfz61g9k2";
  propagatedBuildInputs = [
    attoparsecText attoparsecTextEnumerator blazeBuilder
    blazeBuilderEnumerator enumerator failure text transformers
    xmlTypes
  ];
  meta = {
    homepage = "http://github.com/snoyberg/xml-enumerator";
    description = "Pure-Haskell utilities for dealing with XML with the enumerator package.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
