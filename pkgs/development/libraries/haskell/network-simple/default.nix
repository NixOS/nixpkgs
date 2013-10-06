{ cabal, exceptions, network, transformers }:

cabal.mkDerivation (self: {
  pname = "network-simple";
  version = "0.3.0";
  sha256 = "046nbgdwazbqffcim1gxry1mf35yg41g52zdk86h9whhiwjzlywz";
  buildDepends = [ exceptions network transformers ];
  meta = {
    homepage = "https://github.com/k0001/network-simple";
    description = "Simple network sockets usage patterns";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
