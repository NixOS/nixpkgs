{ cabal, conduit, filesystemConduit, resourcet, systemFilepath
, tagstreamConduit, text, transformers, xmlConduit, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "html-conduit";
  version = "1.1.0";
  sha256 = "11mkr7plhbn8kyki0h362habzhsnlb7yrg4ypy48d0l3i7p7vm53";
  buildDepends = [
    conduit filesystemConduit resourcet systemFilepath tagstreamConduit
    text transformers xmlConduit xmlTypes
  ];
  meta = {
    homepage = "https://github.com/snoyberg/xml";
    description = "Parse HTML documents using xml-conduit datatypes";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
