{cabal} :

cabal.mkDerivation (self : {
  pname = "filepath";
  version = "1.2.0.0";
  sha256 = "14jji7byjlkzsylsnqwfsiw5vsc7nlaisqabzcw9f7nhrxkq2n20";
  meta = {
    homepage = "http://www-users.cs.york.ac.uk/~ndm/filepath/";
    description = "Library for manipulating FilePaths in a cross platform way.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
