{cabal, syb, sourceByName}:

cabal.mkDerivation (self : {
  pname = "ghc-syb";
  version = "dev";
  name = self.fname;
  src = sourceByName "ghc_syb";
  extraBuildInputs = [syb];
  meta = {
    description = "Source code suggestions";
  };
})
