{ cabal, filepath, hslogger, HUnit, mtl, network, parsec
, QuickCheck, random, regexCompat, testpack, time
}:

cabal.mkDerivation (self: {
  pname = "MissingH";
  version = "1.2.0.1";
  sha256 = "0hxyf82g2rz36ks6n136p6brgs0r9cnxfkh4xgl6iw11wbq2rb5m";
  buildDepends = [
    filepath hslogger HUnit mtl network parsec random regexCompat time
  ];
  testDepends = [
    filepath hslogger HUnit mtl network parsec QuickCheck random
    regexCompat testpack time
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
