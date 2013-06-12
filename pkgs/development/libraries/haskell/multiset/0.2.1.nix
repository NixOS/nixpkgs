{ cabal }:

cabal.mkDerivation (self: {
  pname = "multiset";
  version = "0.2.1";
  sha256 = "0snlm6s9ikf5gngdwb7rm7v6017f5bffajv6777y56pjmd7bk9sy";
  meta = {
    description = "The Data.MultiSet container type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
