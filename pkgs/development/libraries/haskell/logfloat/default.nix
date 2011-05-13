{cabal, deepseq}:

cabal.mkDerivation (self : {
  pname = "logfloat";
  version = "0.12.1";
  sha256 = "1k13jjqv4df341hcj9hzrlisfx9wrsmyqvzi6ricx341d9z4ch05";
  meta = {
    description = "Log-domain floating point numbers";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

