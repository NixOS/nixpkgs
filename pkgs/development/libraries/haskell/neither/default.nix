{ cabal, failure, monadPeel, transformers }:

cabal.mkDerivation (self: {
  pname = "neither";
  version = "0.2.0";
  sha256 = "0a2lyx3dvgzj4g6p69x1fma4rmwxrykji3hc4diqgc4hx02p16jh";
  buildDepends = [ failure monadPeel transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/neither";
    description = "Provide versions of Either with good monad and applicative instances.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
