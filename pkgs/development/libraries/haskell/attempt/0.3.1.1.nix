{ cabal, Cabal, failure }:

cabal.mkDerivation (self: {
  pname = "attempt";
  version = "0.3.1.1";
  sha256 = "0yfn8mh7gy6nh689ic6sygf9d7lk44kpj2wahnljl53k6vw7smv5";
  buildDepends = [ Cabal failure ];
  meta = {
    homepage = "http://github.com/snoyberg/attempt/tree/master";
    description = "Concrete data type for handling extensible exceptions as failures";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
