{ cabal, ansiTerminal, ansiWlPprint, hostname, random, regexPosix
, time, xml
}:

cabal.mkDerivation (self: {
  pname = "test-framework";
  version = "0.8.0.3";
  sha256 = "136nw5dapsz3jrnw1pdfkjgplxigpr2mrf6i85154vx342zvw5ar";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal ansiWlPprint hostname random regexPosix time xml
  ];
  meta = {
    homepage = "https://batterseapower.github.io/test-framework/";
    description = "Framework for running and organising tests, with HUnit and QuickCheck support";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
