{ cabal, HUnit, hslogger, mtl, network, parsec, random, regexCompat
}:

cabal.mkDerivation (self: {
  pname = "MissingH";
  version = "1.1.0.3";
  sha256 = "2d566511e8a347189cf864188d97f8406c6958c6f0a6fcf8cb1593c6bae13dbf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    HUnit hslogger mtl network parsec random regexCompat
  ];
  meta = {
    homepage = "http://software.complete.org/missingh";
    description = "Large utility library";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
