{ cabal, ansiTerminal }:

cabal.mkDerivation (self: {
  pname = "ansi-wl-pprint";
  version = "0.6.4";
  sha256 = "0zrhzkmc5ki6q9ac5l16lhnyf9z2raj78gj9n0a7530rcv4ak3k0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ ansiTerminal ];
  meta = {
    homepage = "http://github.com/batterseapower/ansi-wl-pprint";
    description = "The Wadler/Leijen Pretty Printer for colored ANSI terminal output";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
