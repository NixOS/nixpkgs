{ cabal, conduit, filesystemConduit, resourcet, systemFilepath
, tagstreamConduit, text, transformers, xmlConduit, xmlTypes
}:

cabal.mkDerivation (self: {
  pname = "html-conduit";
  version = "0.1.0.3";
  sha256 = "002862if2i9r0ww4q0iapp0j745970pfcmfpi3ni64k41qfqapsn";
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
