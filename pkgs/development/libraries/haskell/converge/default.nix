{cabal} :

cabal.mkDerivation (self : {
  pname = "converge";
  version = "0.1";
  sha256 = "01n5xnzb769rflgzk1f2v2y3yik9q2cmpq3b2pw68pxl1z3qfvpw";
  meta = {
    homepage = "/dev/null";
    description = "Limit operations for converging sequences";
    license = self.stdenv.lib.licenses.publicDomain;
  };
})
