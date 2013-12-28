{ cabal, ansiTerminal, deepseq, either, mtl, optparseApplicative
, regexPosix, stm, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.6";
  sha256 = "00mf8pxwingzywnzgh7dypask1spp18kpiwqjbf1y11dqbs6ib6w";
  buildDepends = [
    ansiTerminal deepseq either mtl optparseApplicative regexPosix stm
    tagged
  ];
  meta = {
    description = "Modern and extensible testing framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
