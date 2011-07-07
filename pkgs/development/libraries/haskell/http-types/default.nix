{cabal, blazeBuilder, caseInsensitive, text}:

cabal.mkDerivation (self : {
  pname = "http-types";
  version = "0.6.5";
  sha256 = "1z2y219170n6rrmmffkg8xa450xzl42zpwahv7m71bxlz4cvxjc1";
  propagatedBuildInputs = [blazeBuilder caseInsensitive text];
  meta = {
    description = "Generic HTTP types for Haskell (for both client and server code)";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

