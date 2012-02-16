{ cabal, Cabal, libedit }:

cabal.mkDerivation (self: {
  pname = "editline";
  version = "0.2.1.0";
  sha256 = "83618e5f86074fdc11d7f5033aa2886284462941be38fa02966acc92712c46e1";
  buildDepends = [ Cabal ];
  extraLibraries = [ libedit ];
  meta = {
    homepage = "http://code.haskell.org/editline";
    description = "Bindings to the editline library (libedit)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
