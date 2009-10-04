{cabal, ansiTerminal}:

cabal.mkDerivation (self : {
  pname = "ansi-wl-pprint";
  version = "0.5.0";
  sha256 = "295e6924409012e3371db1bb5c02475614fcf1ea99e6bff45a5fc84fb13b8284";
  propagatedBuildInputs = [ansiTerminal];
  meta = {
    description = "The Wadler/Leijen Pretty Printer for colored ANSI terminal output";
  };
})  

