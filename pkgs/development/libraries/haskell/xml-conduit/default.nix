{ cabal, attoparsec, attoparsecConduit, blazeBuilder
, blazeBuilderConduit, blazeHtml, blazeMarkup, conduit, dataDefault
, failure, hspec, HUnit, monadControl, resourcet, systemFilepath
, text, transformers, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "xml-conduit";
  version = "1.1.0.4";
  sha256 = "0mbn0xm3br4f645qk1cv09zjlrcws5qdn498iwm5lx4j2ygg9swa";
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
