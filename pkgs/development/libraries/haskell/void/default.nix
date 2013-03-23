{ cabal, hashable, semigroups }:

cabal.mkDerivation (self: {
  pname = "void";
  version = "0.6";
  sha256 = "0g1dja7qcp2d9a4m8j1f4ddyvbl003znyk7yn5w5qiiqr1pacs1n";
  buildDepends = [ hashable semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/void";
    description = "A Haskell 98 logically uninhabited data type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
