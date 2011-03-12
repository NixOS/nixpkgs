{cabal, parsec, syb, xml}:

cabal.mkDerivation (self : {
  pname = "texmath";
  version = "0.5.0.1";
  sha256 = "0kw23b1df7456d2h48g2p7k8nvfv80a8a70xgkq4pn7v50vqipdy";
  propagatedBuildInputs = [parsec syb xml];
  meta = {
    description = "Conversion of LaTeX math formulas to MathML";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

