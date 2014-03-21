{ cabal, ansiTerminal, async, deepseq, mtl, optparseApplicative
, regexTdfa, stm, tagged, unboundedDelays
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.8.0.2";
  sha256 = "0xn0qc1d7bq8s7988x58snq5ipvmi7g87rg89r1l21yxl6a85zw5";
  buildDepends = [
    ansiTerminal async deepseq mtl optparseApplicative regexTdfa stm
    tagged unboundedDelays
  ];
  meta = {
    homepage = "http://documentup.com/feuerbach/tasty";
    description = "Modern and extensible testing framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
