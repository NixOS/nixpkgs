{ cabal, semigroups }:

cabal.mkDerivation (self: {
  pname = "void";
  version = "0.5.5.1";
  sha256 = "1j8rss4b5j4213h40n4nl38p12z275lbsk46dvy4x5s96gqyximp";
  buildDepends = [ semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/void";
    description = "A Haskell 98 logically uninhabited data type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
