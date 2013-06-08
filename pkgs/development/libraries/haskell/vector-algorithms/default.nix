{ cabal, primitive, vector }:

cabal.mkDerivation (self: {
  pname = "vector-algorithms";
  version = "0.5.4.2";
  sha256 = "08pb6mkghf9h5011vxrfdrfq6g26jk4gxmjh9s3hpdiwybf3ab64";
  buildDepends = [ primitive vector ];
  meta = {
    homepage = "http://code.haskell.org/~dolio/";
    description = "Efficient algorithms for vector arrays";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
