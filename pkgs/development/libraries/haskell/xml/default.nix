{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "xml";
  version = "1.3.13";
  sha256 = "04xq2ma2if5gqz16bjrxwigh4vzw6m8i2zk11s5qg3d4z370fdn3";
  buildDepends = [ text ];
  meta = {
    homepage = "http://code.galois.com";
    description = "A simple XML library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
