{ cabal, Cabal, hashable, syb, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "uniplate";
  version = "1.6.6";
  sha256 = "1n3535yaw44v0krslnmfxgkfry6kih6sn17544qqynnz21x7dlfs";
  buildDepends = [ Cabal hashable syb unorderedContainers ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/uniplate/";
    description = "Help writing simple, concise and fast generic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
