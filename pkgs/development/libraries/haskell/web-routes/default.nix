{cabal, mtl, network, parsec, utf8String} :

cabal.mkDerivation (self : {
  pname = "web-routes";
  version = "0.25.2";
  sha256 = "0gspjvk5859zwg55q8fjyz4a0d2p6lf2qwa41b8s6kcqi38nnp08";
  propagatedBuildInputs = [ mtl network parsec utf8String ];
  meta = {
    description = "Library for maintaining correctness and composability of URLs within an application.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
