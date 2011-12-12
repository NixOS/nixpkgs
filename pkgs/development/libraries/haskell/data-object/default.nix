{ cabal, failure, text, time }:

cabal.mkDerivation (self: {
  pname = "data-object";
  version = "0.3.1.8";
  sha256 = "0v7kn6rv71fhf2l7ll7plzr90irm2fyp25lskv2zwazp4swhw52x";
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
