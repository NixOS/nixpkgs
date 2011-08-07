{cabal, primitive} :

cabal.mkDerivation (self : {
  pname = "vector";
  version = "0.7.1";
  sha256 = "1cdbkabw49pgc1j5h96inpmhn8ly230885d22smmynrq369pmg07";
  propagatedBuildInputs = [ primitive ];
  meta = {
    homepage = "http://code.haskell.org/vector";
    description = "Efficient Arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
