{ cabal, attoparsec, conduit, hspec, resourcet, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "attoparsec-conduit";
  version = "1.0.1";
  sha256 = "14b6ym5sjvg1x82ijydhrjk5445kg0fvwqzqwqld59akbqb6fpg5";
  buildDepends = [ attoparsec conduit text transformers ];
  testDepends = [ attoparsec conduit hspec resourcet text ];
  meta = {
    homepage = "http://github.com/snoyberg/conduit";
    description = "Consume attoparsec parsers via conduit";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
