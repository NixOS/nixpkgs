{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "transformers-base";
  version = "0.4";
  sha256 = "1g6q1g0ddr3jjjir0h1g6bc0zpq5gxcyx4q93fidraxxz2pmfrs0";
  buildDepends = [ transformers ];
  meta = {
    homepage = "https://github.com/mvv/transformers-base";
    description = "Lift computations from the bottom of a transformer stack";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
