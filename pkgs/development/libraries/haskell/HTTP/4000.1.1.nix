{ cabal, Cabal, mtl, network, parsec }:

cabal.mkDerivation (self: {
  pname = "HTTP";
  version = "4000.1.1";
  sha256 = "09khx5fb673a0d7m3bl39xjdxvc60m52rmm4865cha2mby0zidy3";
  buildDepends = [ Cabal mtl network parsec ];
  meta = {
    homepage = "http://projects.haskell.org/http/";
    description = "A library for client-side HTTP";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
