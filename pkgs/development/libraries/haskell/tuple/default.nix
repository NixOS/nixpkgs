{cabal, OneTuple}:

cabal.mkDerivation (self : {
  pname = "tuple";
  version = "0.2.0.1";
  sha256 = "1c4vf798rjwshnk04avyjp4rjzj8i9qx4yksv00m3rjy6psr57xg";
  propagatedBuildInputs = [OneTuple];
  meta = {
    description = "Various functions on tuples";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

