{ cabal, hashable, syb, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "uniplate";
  version = "1.6.7";
  sha256 = "1f71dinmp3vmx9j0a1sxm0f8gzxknsvhnyb8sxfjrvpvixzyg0dx";
  buildDepends = [ hashable syb unorderedContainers ];
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
