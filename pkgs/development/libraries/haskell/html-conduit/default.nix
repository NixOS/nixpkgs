{ cabal, conduit, conduitExtra, hspec, HUnit, resourcet
, systemFilepath, tagstreamConduit, text, transformers, xmlConduit
, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "html-conduit";
  version = "1.1.0.4";
  sha256 = "1bl6h38fvhiidzxly49l7jickcg0s4fy59m4cizfjarxll9cspwb";
  buildDepends = [
    conduit conduitExtra resourcet systemFilepath tagstreamConduit text
    transformers xmlConduit xmlTypes
  ];
  testDepends = [ hspec HUnit xmlConduit ];
  meta = {
    homepage = "https://github.com/snoyberg/xml";
    description = "Parse HTML documents using xml-conduit datatypes";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
