{ cabal, mtl, RepLib, transformers }:

cabal.mkDerivation (self: {
  pname = "unbound";
  version = "0.4";
  sha256 = "0s4aybbxz5qvkf09wn65qavw10hk0rsyyc2d0ydr02rzz10vd270";
  buildDepends = [ mtl RepLib transformers ];
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
