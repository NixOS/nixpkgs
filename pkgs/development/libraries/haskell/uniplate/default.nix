{ cabal, syb }:

cabal.mkDerivation (self: {
  pname = "uniplate";
  version = "1.6.2";
  sha256 = "1lns0llhszk68jnq5if3xrk997idzszqc267q63kkdwp1zxdicrd";
  buildDepends = [ syb ];
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
