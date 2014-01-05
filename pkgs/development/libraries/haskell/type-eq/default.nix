{ cabal }:

cabal.mkDerivation (self: {
  pname = "type-eq";
  version = "0.4";
  sha256 = "1cvbqxwkiybxbpzr98yl2pnx5w4zrr340z86q40zirgr1f0ch674";
  meta = {
    homepage = "http://github.com/glaebhoerl/type-eq";
    description = "Type equality evidence you can carry around";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
