{cabal, network}:

cabal.mkDerivation (self : {
  pname = "sendfile";
  version = "0.6.2";
  sha256 = "2d7bf7fdcae7e2ffa24bf70bc1bdc7ea4e6b1726f6cee63cd14c2eeb5545749a";
  propagatedBuildInputs = [network];
  meta = {
    description = "A portable sendfile library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

