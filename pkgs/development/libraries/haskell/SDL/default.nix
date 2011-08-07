{cabal, SDL} :

cabal.mkDerivation (self : {
  pname = "SDL";
  version = "0.6.2";
  sha256 = "1fqj3sw709q28rmjzcffa3k1mcp7r9cvdrrqmcppaz5yv63ychly";
  propagatedBuildInputs = [ SDL ];
  meta = {
    description = "Binding to libSDL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
