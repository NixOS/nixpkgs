{ cabal, attoparsec, BoundedChan, bytestringLexing, HUnit, mtl
, network, resourcePool, testFramework, testFrameworkHunit, time
, vector
}:

cabal.mkDerivation (self: {
  pname = "hedis";
  version = "0.6.5";
  sha256 = "1kn8i49yxms1bpjwpy4m8vyycgi755zvy4zc66w068nmnd1kiykh";
  buildDepends = [
    attoparsec BoundedChan bytestringLexing mtl network resourcePool
    time vector
  ];
  testDepends = [ HUnit mtl testFramework testFrameworkHunit time ];
  meta = {
    homepage = "https://github.com/informatikr/hedis";
    description = "Client library for the Redis datastore: supports full command set, pipelining";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
  doCheck = false;
})
