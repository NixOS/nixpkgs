{ cabal, conduit, hspec, HUnit, monadControl, monadLogger
, persistent, persistentSqlite, persistentTemplate, QuickCheck
, resourcet, tagged, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "esqueleto";
  version = "1.4.1";
  sha256 = "0b2gwsd6014fhmq8lipc299n6ndak7fv6dmrvi9vgasw0a665ryj";
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
    homepage = "https://github.com/meteficha/esqueleto";
    description = "Bare bones, type-safe EDSL for SQL queries on persistent backends";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
