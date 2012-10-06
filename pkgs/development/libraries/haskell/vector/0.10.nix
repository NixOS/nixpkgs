{ cabal, deepseq, primitive }:

cabal.mkDerivation (self: {
  pname = "vector";
  version = "0.10";
  sha256 = "0lwhsdg7wv6gwjswakf2d1h9w7lp4pznab0mz6xg5q48pgknrcig";
  buildDepends = [ deepseq primitive ];
  meta = {
    homepage = "http://code.haskell.org/vector";
    description = "Efficient Arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
