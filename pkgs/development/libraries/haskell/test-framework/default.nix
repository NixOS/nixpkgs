{ cabal, ansiTerminal, ansiWlPprint, extensibleExceptions, hostname
, random, regexPosix, time, xml
}:

cabal.mkDerivation (self: {
  pname = "test-framework";
  version = "0.6.1";
  sha256 = "1rx2c3yckw50vrydswb61ngvp27yxcimm5q6jcyqpn16fpkvxijw";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
