{ cabal, attoparsec, conduit, hspec, resourcet, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "attoparsec-conduit";
  version = "1.0.1.2";
  sha256 = "1j05r7mvm83wgnka7asmwd1dj4ajkg548mryyhpr7dd53vn5lbx0";
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
