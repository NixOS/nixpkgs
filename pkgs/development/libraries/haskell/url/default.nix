{cabal, utf8String}:

cabal.mkDerivation (self : {
  pname = "url";
  version = "2.1.2";
  sha256 = "2cf5c4296418afe3940ae4de66d867897b1382cc4d37a0b9a5ccffa16743ef91";
  propagatedBuildInputs = [utf8String];
  meta = {
    description = "A library for working with URLs";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

