{ cabal, conduit, hspec, HUnit, resourcet, systemFilepath
, tagstreamConduit, text, transformers, xmlConduit, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "html-conduit";
  version = "1.1.0.3";
  sha256 = "08f8dqndd2smjf5zycpsjsl50z9rqgi4ynlks4paw1xqlin0n1cl";
  buildDepends = [
    conduit resourcet systemFilepath tagstreamConduit text transformers
    xmlConduit xmlTypes
  ];
  testDepends = [ hspec HUnit xmlConduit ];
  meta = {
    homepage = "https://github.com/snoyberg/xml";
    description = "Parse HTML documents using xml-conduit datatypes";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
