{ cabal, HUnit, mtl }:

cabal.mkDerivation (self: {
  pname = "syb";
  version = "0.4.1";
  sha256 = "1lkh4rrqdzvb8kyry07x2z88v478hrw5cp8wmhjgpg0ck8ywncma";
  testDepends = [ HUnit mtl ];
  doCheck = self.stdenv.lib.versionOlder self.ghc.version "7.9";
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/GenericProgramming/SYB";
    description = "Scrap Your Boilerplate";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
