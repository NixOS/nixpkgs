{cabal}:

cabal.mkDerivation (self : {
  pname = "ListLike";
  version = "3.0.1";
  sha256 = "1366ipy33fphjjk583c62rsyfwh36i5lbnip1v8r089c9glvwkxf";
  meta = {
    description = "Generic support for list-like structures";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
