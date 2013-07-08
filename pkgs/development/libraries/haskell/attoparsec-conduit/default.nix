{ cabal, attoparsec, conduit, hspec, resourcet, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "attoparsec-conduit";
  version = "1.0.1.1";
  sha256 = "0v6d5a720fksvgaysbhqfzsq9a9h0l37yw3dbskxljbdy66gqsh0";
  buildDepends = [ attoparsec conduit text transformers ];
  testDepends = [ attoparsec conduit hspec resourcet text ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Consume attoparsec parsers via conduit";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
