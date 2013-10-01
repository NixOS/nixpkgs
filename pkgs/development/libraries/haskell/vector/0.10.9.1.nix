{ cabal, deepseq, primitive }:

cabal.mkDerivation (self: {
  pname = "vector";
  version = "0.10.9.1";
  sha256 = "1rdx0r7bwx6217ip9mg9yfymvgv52szqv63y89p41b8sfklmcmi0";
  buildDepends = [ deepseq primitive ];
  meta = {
    homepage = "https://github.com/haskell/vector";
    description = "Efficient Arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
