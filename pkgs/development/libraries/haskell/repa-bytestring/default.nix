{cabal, repa, vector}:

cabal.mkDerivation (self : {
  pname = "repa-bytestring";
  version = "2.0.0.3";
  sha256 = "05kc5d8j4m5g515syvz5jkbjvhhf3jxkak4w6pvyhx6nmzgywrk5";
  propagatedBuildInputs = [repa vector];
  meta = {
    description = "Conversions between Repa Arrays and ByteStrings";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

