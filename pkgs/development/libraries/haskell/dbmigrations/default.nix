{ cabal, configurator, fgl, filepath, HDBC, HDBCPostgresql
, HDBCSqlite3, HUnit, mtl, random, text, time, yamlLight
}:

cabal.mkDerivation (self: {
  pname = "dbmigrations";
  version = "0.8";
  sha256 = "0m1zvc61y0n7p66iwsb8wzwgivxnc08cm1h3xvf1jnwrv294dwch";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    configurator fgl filepath HDBC HDBCPostgresql HDBCSqlite3 HUnit mtl
    random text time yamlLight
  ];
  jailbreak = true;
  meta = {
    description = "An implementation of relational database \"migrations\"";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
