{cabal, deepseq}:

cabal.mkDerivation (self : {
  pname = "parallel";
  version = "2.2.0.1"; # Haskell Platform 2010.1.0.0 and 2010.2.0.0
  sha256 = "255310023138ecf618c8b450203fa2fc65feb68cd08ee4d369ceae72054168fd";
  propagatedBuildInputs = [deepseq];
  meta = {
    description = "parallel programming library";
  };
})  

