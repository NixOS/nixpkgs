{cabal, fclabels, parsec, safe, split, utf8String, bimap}:

cabal.mkDerivation (self : {
  pname = "salvia-protocol";
  version = "1.0.1";
  sha256 = "6b2312e52efaa81feec7461b1a3db77e1f2a8dfd829ae878b614c206a5e48928";
  propagatedBuildInputs = [fclabels parsec safe split utf8String bimap];
  meta = {
    description = "Salvia webserver protocol suite";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

