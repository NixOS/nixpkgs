{ cabal, mtl, network, parsec, utf8String }:

cabal.mkDerivation (self: {
  pname = "web-routes";
  version = "0.25.3";
  sha256 = "09bqz7vn2050jr67m3rrqi0krfxa9n1fxm9rgi3c837g522nb4kk";
  buildDepends = [ mtl network parsec utf8String ];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
