{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "regex-base";
  version = "0.93.1"; # Haskell Platform 2010.1.0.0
  sha256 = "24a0e76ab308517a53d2525e18744d9058835626ed4005599ecd8dd4e07f3bef";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Replaces/Ehances Text.Regex";
  };
})  

