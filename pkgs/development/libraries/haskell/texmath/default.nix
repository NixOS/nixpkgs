{cabal, cgi, json, parsec, xml}:

cabal.mkDerivation (self : {
  pname = "texmath";
  version = "0.3.0.2";
  sha256 = "8d2bb26fc5aab09ae92d2c194ec39acb4e04c054ad2caf1a1db0dc9b53b4b1d4";
  propagatedBuildInputs = [cgi json parsec xml];
  meta = {
    description = "Conversion of LaTeX math formulas to MathML";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

