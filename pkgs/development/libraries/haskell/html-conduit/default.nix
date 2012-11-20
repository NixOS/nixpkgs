{ cabal, conduit, filesystemConduit, resourcet, systemFilepath
, tagstreamConduit, text, transformers, xmlConduit, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "html-conduit";
  version = "0.1.0.4";
  sha256 = "1g217856dz1ad545slk020n5w0la4yyd5ygva2gg2g0999padi78";
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
