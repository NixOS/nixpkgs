{ cabal, deepseq, hashable, text }:

cabal.mkDerivation (self: {
  pname = "case-insensitive";
  version = "1.0";
  sha256 = "1x437b5yyh930a5dr642lvfdgpx12w4ms70whiw1ffjjhssb88zk";
  buildDepends = [ deepseq hashable text ];
  meta = {
    homepage = "https://github.com/basvandijk/case-insensitive";
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
