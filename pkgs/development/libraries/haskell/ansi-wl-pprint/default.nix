{cabal, ansiTerminal} :

cabal.mkDerivation (self : {
  pname = "ansi-wl-pprint";
  version = "0.6.3";
  sha256 = "1cpkfn1ld0sjysksdsxxwwy1b17s4smmzk8y88y9mb81vgwlalkl";
  propagatedBuildInputs = [ ansiTerminal ];
  meta = {
    homepage = "http://github.com/batterseapower/ansi-wl-pprint";
    description = "The Wadler/Leijen Pretty Printer for colored ANSI terminal output";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
