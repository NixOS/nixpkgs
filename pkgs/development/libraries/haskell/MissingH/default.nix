{ cabal, filepath, hslogger, HUnit, mtl, network, parsec
, QuickCheck, random, regexCompat, testpack, time
}:

cabal.mkDerivation (self: {
  pname = "MissingH";
  version = "1.2.0.2";
  sha256 = "1wrrfa8dy0h0c53f1zjzwdkj8wkwsbi6qhv35wwlaz39dk32c4nn";
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
