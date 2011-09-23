{ cabal, time }:

cabal.mkDerivation (self: {
  pname = "random";
  version = "1.0.1.0";
  sha256 = "1ghdmjzcn6n02x4gffa4g7wag4g7azrgxk3nsc5fqn9iny6rwp2i";
  buildDepends = [ time ];
  meta = {
    description = "random number library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
