{ cabal, configurator, fgl, filepath, HDBC, HDBCPostgresql
, HDBCSqlite3, HUnit, mtl, random, text, time, yamlLight
}:

cabal.mkDerivation (self: {
  pname = "dbmigrations";
  version = "0.7";
  sha256 = "1mpmka6jszip8sm8k9mrk0fg1q7wp36n0szyiqy7fnbzijfw0xlz";
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
