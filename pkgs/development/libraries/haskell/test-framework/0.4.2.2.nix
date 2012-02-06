{ cabal, ansiTerminal, ansiWlPprint, extensibleExceptions, hostname
, random, regexPosix, time, xml
}:

cabal.mkDerivation (self: {
  pname = "test-framework";
  version = "0.4.2.2";
  sha256 = "1lwdx4z9j5wxbmmlakf6knirdhi0ic6xpmhrj9ipa5ybw2zszakr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal ansiWlPprint extensibleExceptions hostname random
    regexPosix time xml
  ];
  meta = {
    homepage = "http://batterseapower.github.com/test-framework/";
    description = "Framework for running and organising tests, with HUnit and QuickCheck support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
