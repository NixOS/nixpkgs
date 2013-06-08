{ cabal, ansiTerminal }:

cabal.mkDerivation (self: {
  pname = "ansi-wl-pprint";
  version = "0.6.6";
  sha256 = "1zkbiv5cpdgjiyn2nrrha29r84al7jg6647flqmc8riz2nn91zqy";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ ansiTerminal ];
  meta = {
    homepage = "http://github.com/batterseapower/ansi-wl-pprint";
    description = "The Wadler/Leijen Pretty Printer for colored ANSI terminal output";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
