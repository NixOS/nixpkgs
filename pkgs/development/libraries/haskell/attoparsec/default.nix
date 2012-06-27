{ cabal, deepseq, text }:

cabal.mkDerivation (self: {
  pname = "attoparsec";
  version = "0.10.2.0";
  sha256 = "0hvkx63knhxdc06lkv2avz2dblbvn0hhvckfqyr22ls1qrpgz71c";
  buildDepends = [ deepseq text ];
  meta = {
    homepage = "https://github.com/bos/attoparsec";
    description = "Fast combinator parsing for bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
