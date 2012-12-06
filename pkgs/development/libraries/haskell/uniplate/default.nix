{ cabal, hashable, syb, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "uniplate";
  version = "1.6.8";
  sha256 = "0ic1fqm6i7b9lvv2m5l591xw5wkc80lvyvwdvvxbzsbb5vz7kphy";
  buildDepends = [ hashable syb unorderedContainers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/uniplate/";
    description = "Help writing simple, concise and fast generic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
