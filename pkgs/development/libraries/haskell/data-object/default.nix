{ cabal, Cabal, failure, text, time }:

cabal.mkDerivation (self: {
  pname = "data-object";
  version = "0.3.1.9";
  sha256 = "0z8m23kw8mj6hhy1r8y1vvlxxpwl273dhanszig2673a1sw0l98l";
  buildDepends = [ Cabal failure text time ];
  meta = {
    homepage = "http://github.com/snoyberg/data-object/tree/master";
    description = "Represent hierachichal structures, called objects in JSON. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
