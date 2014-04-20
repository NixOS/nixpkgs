{ cabal, failure }:

cabal.mkDerivation (self: {
  pname = "attempt";
  version = "0.4.0.1";
  sha256 = "1gvq04ds62kk88r2210mxd1fggp6vf5p8j5hci9vqkkss1hy9rxh";
  buildDepends = [ failure ];
  meta = {
    homepage = "http://github.com/snoyberg/attempt/tree/master";
    description = "Concrete data type for handling extensible exceptions as failures. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
