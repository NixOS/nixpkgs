{cabal, primitive}:

cabal.mkDerivation (self : {
  pname = "vector";
  version = "0.7.0.1";
  sha256 = "147kwm3p6w1qg1sg3ls7i8zj3mcnyxf80il4r5kz5fd3n1ibvyxj";
  propagatedBuildInputs = [primitive];
  meta = {
    description = "Efficient arrays";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

