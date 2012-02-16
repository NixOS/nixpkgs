{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "async";
  version = "1.4";
  sha256 = "1d24bcvmw687jcf75wgavlhfs55f0va02xhl4xdnj2lrlr19s5dl";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://gitorious.org/async/";
    description = "Asynchronous Computations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
