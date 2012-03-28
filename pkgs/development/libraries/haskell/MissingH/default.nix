{ cabal, filepath, hslogger, HUnit, mtl, network, parsec, random
, regexCompat
}:

cabal.mkDerivation (self: {
  pname = "MissingH";
  version = "1.1.1.0";
  sha256 = "1i2fdr6p0jnn9w865ngjcchbsamrvnvdf9c4vzhjhzy500z2k1ry";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    filepath hslogger HUnit mtl network parsec random regexCompat
  ];
  meta = {
    homepage = "http://software.complete.org/missingh";
    description = "Large utility library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
