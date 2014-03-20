{ cabal, conduit, hspec, HUnit, resourcet, systemFilepath
, tagstreamConduit, text, transformers, xmlConduit, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "html-conduit";
  version = "1.1.0.2";
  sha256 = "12a5hb9sf4sd11sjhwwp84k8whkxs7hqfyni2hi247fii2ldkfax";
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
