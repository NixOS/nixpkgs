{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "regex-base";
  version = "0.72.0.2"; # Haskell Platform 2009.0.0
  sha256 = "38a4901b942fea646a422d52c52ef14eec4d6561c258b3c54cd96a8a354141ee";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Replaces/Ehances Text.Regex";
  };
})  

