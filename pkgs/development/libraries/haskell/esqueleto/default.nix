{ cabal, conduit, hspec, HUnit, monadControl, monadLogger
, persistent, persistentSqlite, persistentTemplate, QuickCheck
, resourcet, tagged, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "esqueleto";
  version = "1.4.1.3";
  sha256 = "0n2h1ymyr92a3qaadiff3xxwdxdc8l92kfbag8rh27gi736w28y4";
  buildDepends = [
    conduit monadLogger persistent resourcet tagged text transformers
    unorderedContainers
  ];
  testDepends = [
    conduit hspec HUnit monadControl monadLogger persistent
    persistentSqlite persistentTemplate QuickCheck resourcet text
    transformers
  ];
  meta = {
    homepage = "https://github.com/prowdsponsor/esqueleto";
    description = "Type-safe EDSL for SQL queries on persistent backends";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
