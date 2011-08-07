{cabal} :

cabal.mkDerivation (self : {
  pname = "semigroups";
  version = "0.7.1";
  sha256 = "1l83i62i98j2r8mqbjpy2sy303y1igxvdfn8c4nxxyi70qgz5fk1";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
