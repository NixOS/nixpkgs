{cabal, cgi, json, parsec, xml}:

cabal.mkDerivation (self : {
  pname = "texmath";
  version = "0.2.0.3";
  sha256 = "d355a298d28b9f5356926c2d2942f28ed07afa9d944cadfa47d8cdec73725b55";
  propagatedBuildInputs = [cgi json parsec xml];
  meta = {
    description = "Conversion of LaTeX math formulas to MathML";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

