{cabal}:

cabal.mkDerivation (self : {
  pname = "dlist";
  version = "0.5";
  sha256 = "1shr5wlpha68h82gwpndr5441847l01gh3j7szyvnmgzkr0fb027";
  propagatedBuildInputs = [];
  meta = {
    description = "Differences lists";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

