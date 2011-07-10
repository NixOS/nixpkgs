{cabal, ansiTerminal}:

cabal.mkDerivation (self : {
  pname = "ansi-wl-pprint";
  version = "0.6.3";
  sha256 = "1cpkfn1ld0sjysksdsxxwwy1b17s4smmzk8y88y9mb81vgwlalkl";
  propagatedBuildInputs = [ansiTerminal];
  meta = {
    description = "The Wadler/Leijen Pretty Printer for colored ANSI terminal output";
  };
})

