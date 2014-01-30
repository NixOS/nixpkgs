{ cabal, conduit, hspec, HUnit, monadControl, monadLogger
, persistent, persistentSqlite, persistentTemplate, QuickCheck
, resourcet, tagged, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "esqueleto";
  version = "1.3.4.5";
  sha256 = "0fw57dn67gx5v7drd4g7xbj1z614sr3lxw7gcciypnjc7qkqjgv7";
  buildDepends = [
    conduit monadLogger persistent resourcet tagged text transformers
    unorderedContainers
  ];
  testDepends = [
    conduit hspec HUnit monadControl monadLogger persistent
    persistentSqlite persistentTemplate QuickCheck text transformers
  ];
  meta = {
    homepage = "https://github.com/meteficha/esqueleto";
    description = "Bare bones, type-safe EDSL for SQL queries on persistent backends";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
