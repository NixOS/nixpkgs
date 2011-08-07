{cabal, hashable, text} :

cabal.mkDerivation (self : {
  pname = "case-insensitive";
  version = "0.3";
  sha256 = "0k3y09ak4k0jwx7bh5awcznw064xgf6yzidq3jalif7m3c9bv5q7";
  propagatedBuildInputs = [ hashable text ];
  meta = {
    description = "Case insensitive string comparison";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
