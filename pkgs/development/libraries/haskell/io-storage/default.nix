{ cabal }:

cabal.mkDerivation (self: {
  pname = "io-storage";
  version = "0.3";
  sha256 = "1ga9bd7iri6vlsxnjx765yy3bxc4lbz644wyw88yzvpjgz6ga3cs";
  meta = {
    homepage = "http://github.com/willdonnelly/io-storage";
    description = "A key-value store in the IO monad";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
