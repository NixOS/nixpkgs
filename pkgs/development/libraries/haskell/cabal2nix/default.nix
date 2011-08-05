{cabal}:

cabal.mkDerivation (self : {
  pname = "cabal2nix";
  version = "1.2";
  sha256 = "f60dbb36dc73351e1891d2b31ae66c465955c46b87eedb0928bcf61b9a7eff54";
  propagatedBuildInputs = [];
  meta = {
    homepage = "http://github.com/peti/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
  };
})
