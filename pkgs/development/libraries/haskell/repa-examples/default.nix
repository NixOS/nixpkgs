{cabal, repa, repaAlgorithms, repaIO, vector, llvm} :

cabal.mkDerivation (self : {
  pname = "repa-examples";
  version = "2.1.0.2";
  sha256 = "056y2x8kada4d6a89sni2469c736z3d9ldp188n3i58h4kjqqfq7";
  extraBuildInputs = [ llvm ];
  propagatedBuildInputs = [ repa repaAlgorithms repaIO vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Examples using the Repa array library.";
    license = self.stdenv.lib.licenses.bsd3;
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

