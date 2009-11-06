{cabal, ansiTerminal, split, text}:

cabal.mkDerivation (self : {
  pname = "mpppc";
  version = "0.1.0";
  sha256 = "73796138cc10df77217568d59fb999567436bedefaa8579ed6648c6cfb841c86";
  propagatedBuildInputs = [ansiTerminal split text];
  meta = {
    description = "Multi-dimensional parametric pretty-printer with color";
  };
})  

