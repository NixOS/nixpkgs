{cabal}:

cabal.mkDerivation (self : {
  pname = "OneTuple";
  version = "0.2.1";
  sha256 = "1x52b68zh3k9lnps5s87kzan7dzvqp6mrwgayjq15w9dv6v78vsb";
  meta = {
    description = "Singleton Tuple";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

