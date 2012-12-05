{ cabal, ansiTerminal, ansiWlPprint, extensibleExceptions, hostname
, random, regexPosix, time, xml
}:

cabal.mkDerivation (self: {
  pname = "test-framework";
  version = "0.7.0";
  sha256 = "1v2kv59j98lmmgggxq8i3yq8v750l3c5xp7aq1az7k6n224yblab";
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
