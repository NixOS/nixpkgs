{ cabal, failure, text, time }:

cabal.mkDerivation (self: {
  pname = "data-object";
  version = "0.3.1.7";
  sha256 = "0b4jai09nx3h2vfj5f2q1wp0wldvkjygyzkgrrc6hnsfx2qv8qf7";
  buildDepends = [ failure text time ];
  meta = {
    homepage = "http://github.com/snoyberg/data-object/tree/master";
    description = "Represent hierachichal structures, called objects in JSON";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
