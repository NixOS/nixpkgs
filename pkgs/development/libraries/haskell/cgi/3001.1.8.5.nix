{ cabal, MonadCatchIOMtl, mtl, network, parsec, xhtml }:

cabal.mkDerivation (self: {
  pname = "cgi";
  version = "3001.1.8.5";
  sha256 = "0ffvn9ki5yq2zc65afmy04353v4s66lajc7y563fhj2kz5ib5ks6";
  buildDepends = [ MonadCatchIOMtl mtl network parsec xhtml ];
  meta = {
    homepage = "http://andersk.mit.edu/haskell/cgi/";
    description = "A library for writing CGI programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
