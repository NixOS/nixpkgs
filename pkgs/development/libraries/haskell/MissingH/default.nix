{ cabal, errorcallEqInstance, filepath, hslogger, HUnit, mtl
, network, parsec, QuickCheck, random, regexCompat, testpack, time
}:

cabal.mkDerivation (self: {
  pname = "MissingH";
  version = "1.2.1.0";
  sha256 = "08zpzfhl31w35x13vapimwd508j4nydi8v3vid668r4fkqnymbss";
  buildDepends = [
    filepath hslogger HUnit mtl network parsec random regexCompat time
  ];
  testDepends = [
    errorcallEqInstance filepath hslogger HUnit mtl network parsec
    QuickCheck random regexCompat testpack time
  ];
  doCheck = false;
  meta = {
    homepage = "http://software.complete.org/missingh";
    description = "Large utility library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
