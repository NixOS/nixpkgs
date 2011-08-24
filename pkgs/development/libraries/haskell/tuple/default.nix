{ cabal, OneTuple }:

cabal.mkDerivation (self: {
  pname = "tuple";
  version = "0.2.0.1";
  sha256 = "1c4vf798rjwshnk04avyjp4rjzj8i9qx4yksv00m3rjy6psr57xg";
  buildDepends = [ OneTuple ];
  meta = {
    description = "Various functions on tuples";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
