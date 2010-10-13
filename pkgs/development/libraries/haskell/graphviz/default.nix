{cabal, colour, fgl, polyparse, transformers, QuickCheck}:

cabal.mkDerivation (self : {
  pname = "graphviz";
  version = "2999.10.0.1";
  sha256 = "5a3aebd3874303dcf554aef3bf511dd22e72053a9672c823d1d820d2b90ca076";
  propagatedBuildInputs = [colour fgl polyparse transformers QuickCheck];
  meta = {
    description = "Bindings for the Dot language (Graphviz)";
    license = "BSD3";
  };
})  

