{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.10.3.0";
  sha256 = "1l4cnfgnynrprfvx0p3n6kca8arsmvb1yxb9ir782rrk537jci50";
  buildDepends = [ deepseq text ];
  meta = {
    homepage = "https://github.com/bos/attoparsec";
    description = "Fast combinator parsing for bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
