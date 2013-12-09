{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, blazeHtml, blazeMarkup, conduit, dataDefault
, deepseq, failure, hspec, HUnit, monadControl, resourcet
, systemFilepath, text, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-conduit";
  version = "1.1.0.9";
  sha256 = "01sx8yblknv0dyi7z6k6icfvwjvl4dyhrka1d6y1793xcp1mkxs6";
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
