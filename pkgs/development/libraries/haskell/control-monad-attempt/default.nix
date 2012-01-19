{ cabal, attempt, transformers }:

cabal.mkDerivation (self: {
  pname = "control-monad-attempt";
  version = "0.3.0.1";
  sha256 = "140n27vdbyjz5qycrwlrmyd7s48fxcl6msl16g7czg40k5y23j5s";
  buildDepends = [ attempt transformers ];
  meta = {
    homepage = "http://github.com/snoyberg/control-monad-attempt";
    description = "Monad transformer for attempt. (deprecated)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
