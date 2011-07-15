{cabal, text}:

cabal.mkDerivation (self : {
  pname = "web-routes-quasi";
  version = "0.7.0.1";
  sha256 = "1khrf5kbw285hddyyzcz2mx4qpz46mdmlm31jszag2ay64gw35gw";
  propagatedBuildInputs = [text];
  meta = {
    description = "Define data types and parse/build functions for web-routes via a quasi-quoted DSL";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
