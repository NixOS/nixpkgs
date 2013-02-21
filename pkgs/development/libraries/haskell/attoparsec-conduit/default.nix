{ cabal, attoparsec, conduit, text, transformers }:

cabal.mkDerivation (self: {
  pname = "attoparsec-conduit";
  version = "1.0.0";
  sha256 = "1aw071qcwhxwpd6azhgaiia97rhj50rms4pysbc19iihmdih3ib8";
  buildDepends = [ attoparsec conduit text transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Consume attoparsec parsers via conduit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
