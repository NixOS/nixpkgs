{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, blazeHtml, blazeMarkup, conduit, dataDefault
, failure, hspec, HUnit, monadControl, resourcet, systemFilepath
, text, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-conduit";
  version = "1.1.0.3";
  sha256 = "04mnn6j9bbkhvav04gl9cbd4rldl7bwgcapvykwvf2p3nb3d7bi4";
  buildDepends = [
    attoparsec attoparsecConduit blazeBuilder blazeBuilderConduit
    blazeHtml blazeMarkup conduit dataDefault failure monadControl
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
