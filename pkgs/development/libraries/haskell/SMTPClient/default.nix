{cabal, hsemail, network}:

cabal.mkDerivation (self : {
  pname = "SMTPClient";
  version = "1.0.2";
  sha256 = "b835cebf22e9281778deeec3ceffeb95aa8ae9c0e1f97e8e9734cf5d87ecba5f";
  propagatedBuildInputs = [hsemail network];
  meta = {
    description = "A simple SMTP client library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

