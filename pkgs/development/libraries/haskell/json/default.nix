{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "json";
  version = "0.4.3";
  sha256 = "56192d1e922cc71ad1aaf31baea8ee7e1f1b862f95bc72f60548caee4a484a87";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Support for serialising Haskell to and from JSON";
  };
})  

