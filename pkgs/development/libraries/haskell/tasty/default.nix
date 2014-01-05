{ cabal, ansiTerminal, deepseq, either, mtl, optparseApplicative
, regexTdfa, stm, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.7";
  sha256 = "0nwhbbm70v2drv6kzdz65wws7gn8ph6583xpb6dw8g4j9aa1shxd";
  buildDepends = [
    ansiTerminal deepseq either mtl optparseApplicative regexTdfa stm
    tagged
  ];
  meta = {
    description = "Modern and extensible testing framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
