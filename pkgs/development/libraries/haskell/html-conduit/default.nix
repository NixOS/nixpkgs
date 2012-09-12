{ cabal, conduit, filesystemConduit, resourcet, systemFilepath
, tagstreamConduit, text, transformers, xmlConduit, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "html-conduit";
  version = "0.1.0.2";
  sha256 = "0r9bnzz6r5q2fgichg8vfjgwyig33diqvj5pxchk97m3m5rqj5k4";
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
