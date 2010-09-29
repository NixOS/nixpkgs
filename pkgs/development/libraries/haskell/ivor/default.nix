{cabal, mtl, parsec, binary}:

cabal.mkDerivation (self : {
  pname = "ivor";
  version = "0.1.12";
  sha256 = "77f17df646afbe5199d4ab0291515013ad1bda471b2690512f752b752a2905f5";
  propagatedBuildInputs = [mtl parsec binary];
  meta = {
    description = "Theorem proving library based on dependent type theory";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

