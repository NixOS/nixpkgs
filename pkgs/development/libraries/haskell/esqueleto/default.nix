{ cabal, conduit, hspec, HUnit, monadControl, monadLogger
, persistent, persistentSqlite, persistentTemplate, QuickCheck
, resourcet, tagged, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "esqueleto";
  version = "1.3.5";
  sha256 = "0lz17fr4by31h1qdw0djbsb1zx9xgll5iphqq18gp587l799iy2p";
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
