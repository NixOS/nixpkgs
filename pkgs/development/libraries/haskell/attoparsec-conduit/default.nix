{ cabal, attoparsec, conduit, text, transformers }:

cabal.mkDerivation (self: {
  pname = "attoparsec-conduit";
  version = "0.5.0.1";
  sha256 = "1qrg524gr9ajdxaqd9gmxpj45d7ga21q27ykr76kjdwxfpqaq6n8";
  buildDepends = [ attoparsec conduit text transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Consume attoparsec parsers via conduit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
