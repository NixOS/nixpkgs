{ cabal }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.8.3.2";
  sha256 = "0g433l4rinc6r2yr91jnl6wh5b2kn5vsrp08cmznkgaz45lb7n7c";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
