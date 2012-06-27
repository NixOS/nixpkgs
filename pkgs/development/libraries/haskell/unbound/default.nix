{ cabal, mtl, RepLib, transformers }:

cabal.mkDerivation (self: {
  pname = "unbound";
  version = "0.4.1";
  sha256 = "1fryjs5byyqha945qy8vyfpq4fzjmnh0jc01wzvk6ri292qipsyn";
  buildDepends = [ mtl RepLib transformers ];
  meta = {
    homepage = "http://code.google.com/p/replib/";
    description = "Generic support for programming with names and binders";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
