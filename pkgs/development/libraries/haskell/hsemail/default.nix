{cabal, mtl, parsec}:

cabal.mkDerivation (self : {
  pname = "hsemail";
  version = "1.6";
  sha256 = "a8ba7e8cfb9213bb2ee61166bc8352e4353560d06f418a0c729aeb1d50b3a1fd";
  propagatedBuildInputs = [mtl parsec];
  meta = {
    description = "Internet Message Parsers";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

