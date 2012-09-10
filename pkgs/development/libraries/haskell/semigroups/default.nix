{ cabal }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.8.4.1";
  sha256 = "05wv5amgg3nqr1if936zl330sv1k4i9p8xzdmgxsmchp4lshyr6n";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
