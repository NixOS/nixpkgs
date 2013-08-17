{ cabal, hashable, syb, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "uniplate";
  version = "1.6.11";
  sha256 = "10ppc9hqc0y17r3y4vdajshrp3956dybna7qa5zm0akgl3pbla9j";
  buildDepends = [ hashable syb unorderedContainers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/uniplate/";
    description = "Help writing simple, concise and fast generic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
