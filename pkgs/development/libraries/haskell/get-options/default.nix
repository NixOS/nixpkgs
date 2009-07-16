{cabal, sourceByName, mtl}:

cabal.mkDerivation (self : {
  pname = "get-options";
  version = "x"; # ? 
  name = self.fname;
  src = sourceByName "getOptions";
  extraBuildInputs = [ mtl ];
  meta = {
    description = "Simple to use get option library";
  };
})
