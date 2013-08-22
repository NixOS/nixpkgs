{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, blazeHtml, blazeMarkup, conduit, dataDefault
, deepseq, failure, hspec, HUnit, monadControl, resourcet
, systemFilepath, text, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-conduit";
  version = "1.1.0.6";
  sha256 = "08kz982c95hcni6zbrflv8kqvy7wccb19plsmwczhzcsifam5a9k";
  buildDepends = [
    attoparsec attoparsecConduit blazeBuilder blazeBuilderConduit
    blazeHtml blazeMarkup conduit dataDefault deepseq failure
    monadControl resourcet systemFilepath text transformers xmlTypes
  ];
  testDepends = [
    blazeMarkup conduit hspec HUnit text transformers xmlTypes
  ];
  meta = {
    homepage = "http://github.com/snoyberg/xml";
    description = "Pure-Haskell utilities for dealing with XML with the conduit package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
