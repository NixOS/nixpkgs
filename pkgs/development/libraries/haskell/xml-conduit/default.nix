{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, blazeHtml, blazeMarkup, conduit, dataDefault
, deepseq, hspec, HUnit, monadControl, resourcet, systemFilepath
, text, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-conduit";
  version = "1.2.0";
  sha256 = "0sh4f645ysj2dzd58a1b1y2pqqcg6khav27lgy2j3fqgm6mryxhj";
  buildDepends = [
    attoparsec attoparsecConduit blazeBuilder blazeBuilderConduit
    blazeHtml blazeMarkup conduit dataDefault deepseq monadControl
    resourcet systemFilepath text transformers xmlTypes
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
