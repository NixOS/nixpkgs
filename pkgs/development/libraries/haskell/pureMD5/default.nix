{cabal, binary}:

cabal.mkDerivation (self : {
  pname = "pureMD5";
  version = "1.0.0.3";
  sha256 = "3698e5bc8a0e20bed91b52f976235e52f2c1dd876aa40e94d6c7be293d67d482";
  propagatedBuildInputs = [binary];
  meta = {
    description = "An unrolled implementation of MD5 purely in Haskell";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

