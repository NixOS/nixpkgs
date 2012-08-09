{ cabal, attoparsec, conduit, text, transformers }:

cabal.mkDerivation (self: {
  pname = "attoparsec-conduit";
  version = "0.5.0";
  sha256 = "17l98kbv2pxcchacy7r4ja0czdklc7r4j8vzv3pi0pjb2s9ih6sq";
  buildDepends = [ attoparsec conduit text transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Consume attoparsec parsers via conduit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
