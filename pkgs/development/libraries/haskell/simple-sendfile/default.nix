{ cabal, Cabal, network }:

cabal.mkDerivation (self: {
  pname = "simple-sendfile";
  version = "0.2.1";
  sha256 = "0mbnqdy7g9jp2d6x9mcrz315b4xhp92as28bxygf7jhc0aai66aq";
  buildDepends = [ Cabal network ];
  meta = {
    description = "Cross platform library for the sendfile system call";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
