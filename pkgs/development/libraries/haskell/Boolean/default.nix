{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "Boolean";
  version = "0.0.1";
  sha256 = "dafcfb2e9d7f7aa24a3d3ceb385424176297cdf6f6044028d42d0fea1cae7765";
  buildDepends = [ Cabal ];
  meta = {
    description = "Generalized booleans";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
