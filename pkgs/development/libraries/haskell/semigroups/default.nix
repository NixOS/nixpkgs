{ cabal }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.8";
  sha256 = "12ly9f1lxzrxvwkcx25cjik7d1f1l2j1rkd0cabgpcg53hz4158c";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
