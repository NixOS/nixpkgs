{ cabal, Cabal, SDL }:

cabal.mkDerivation (self: {
  pname = "SDL";
  version = "0.6.2";
  sha256 = "1fqj3sw709q28rmjzcffa3k1mcp7r9cvdrrqmcppaz5yv63ychly";
  buildDepends = [ Cabal ];
  extraLibraries = [ SDL ];
  meta = {
    description = "Binding to libSDL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
