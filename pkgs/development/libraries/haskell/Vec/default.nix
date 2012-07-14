{ cabal }:

cabal.mkDerivation (self: {
  pname = "Vec";
  version = "1.0";
  sha256 = "1lyi7di92q1f0k08nj7766nm0ygaqdrjdphnb6imvyrsmjrspaqk";
  meta = {
    homepage = "http://github.net/sedillard/Vec";
    description = "Fixed-length lists and low-dimensional linear algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
