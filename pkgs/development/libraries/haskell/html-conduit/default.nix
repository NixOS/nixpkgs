{ cabal, conduit, filesystemConduit, hspec, HUnit, resourcet
, systemFilepath, tagstreamConduit, text, transformers, xmlConduit
, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "html-conduit";
  version = "1.1.0.1";
  sha256 = "0v3zlassakc34i7kzajx63s1rxn516xv7lrib0a4kn4cdlqn7kxs";
  buildDepends = [
    conduit filesystemConduit resourcet systemFilepath tagstreamConduit
    text transformers xmlConduit xmlTypes
  ];
  testDepends = [ hspec HUnit xmlConduit ];
  meta = {
    homepage = "https://github.com/snoyberg/xml";
    description = "Parse HTML documents using xml-conduit datatypes";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
