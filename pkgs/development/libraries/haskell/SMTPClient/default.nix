{cabal, hsemail, network}:

cabal.mkDerivation (self : {
  pname = "SMTPClient";
  version = "1.0.3";
  sha256 = "c9907834565b5b712d50c50823513675b982c8b51e7b95680a3495eccb73ce66";
  propagatedBuildInputs = [hsemail network];
  meta = {
    description = "A simple SMTP client library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

