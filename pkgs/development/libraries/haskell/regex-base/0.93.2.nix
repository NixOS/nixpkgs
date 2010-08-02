{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "regex-base";
  version = "0.93.2"; # Haskell Platform 2010.2.0.0
  sha256 = "20dc5713a16f3d5e2e6d056b4beb9cfdc4368cd09fd56f47414c847705243278";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Replaces/Ehances Text.Regex";
  };
})  

