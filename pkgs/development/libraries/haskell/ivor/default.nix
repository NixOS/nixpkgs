{cabal, mtl, parsec}:

cabal.mkDerivation (self : {
  pname = "ivor";
  version = "0.1.8";
  sha256 = "e51ad07c78ea0cad6fce9253012258dbf7c740198792aa4a446e1f0269a9186d";
  propagatedBuildInputs = [mtl parsec];
  meta = {
    description = "Theorem proving library based on dependent type theory";
  };
})  

