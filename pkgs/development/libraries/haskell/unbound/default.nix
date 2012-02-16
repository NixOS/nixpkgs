{ cabal, Cabal, mtl, RepLib, transformers }:

cabal.mkDerivation (self: {
  pname = "unbound";
  version = "0.3.1";
  sha256 = "13k53dcap8knvl2qzcykx838laas34xfc0480705vzl1z9z1xppz";
  buildDepends = [ Cabal mtl RepLib transformers ];
  noHaddock = true;
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic support for programming with names and binders";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
