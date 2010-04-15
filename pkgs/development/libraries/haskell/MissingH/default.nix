{cabal, HUnit, hslogger, network, parsec, regexCompat}:

cabal.mkDerivation (self : {
  pname = "MissingH";
  version = "1.1.0.3";
  sha256 = "2d566511e8a347189cf864188d97f8406c6958c6f0a6fcf8cb1593c6bae13dbf";
  propagatedBuildInputs = [HUnit hslogger network parsec regexCompat];
  meta = {
    description = "Large utility library";
    license = "GPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

