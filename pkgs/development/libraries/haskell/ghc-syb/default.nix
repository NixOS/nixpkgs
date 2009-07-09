{cabal, syb, sourceByName}:

cabal.mkDerivation (self : {
  pname = "hlint";
  version = "1.4";
  name = self.fname;
  src = sourceByName "ghc_syb";
  extraBuildInputs = [syb];
  meta = {
    description = "Source code suggestions";
  };
})
