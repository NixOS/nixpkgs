{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, blazeHtml, blazeMarkup, conduit, dataDefault
, failure, monadControl, resourcet, systemFilepath, text
, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-conduit";
  version = "1.0.3.1";
  sha256 = "1000gbdwfp98s44kkp793lmqrdm046phwxcvlik20b2485ml8yrj";
  buildDepends = [
    attoparsec attoparsecConduit blazeBuilder blazeBuilderConduit
    blazeHtml blazeMarkup conduit dataDefault failure monadControl
    resourcet systemFilepath text transformers xmlTypes
  ];
  meta = {
    homepage = "http://github.com/snoyberg/xml";
    description = "Pure-Haskell utilities for dealing with XML with the conduit package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
