{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "failure";
  version = "0.2.0.2";
  sha256 = "0hvcsn7qx00613f23vvb3vjpjlcy0nfavsai9f6s3yvmyssk5kfv";
  buildDepends = [ transformers ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Failure";
    description = "A simple type class for success/failure computations. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
