{ cabal, ansiTerminal, async, deepseq, mtl, optparseApplicative
, regexTdfaRc, stm, tagged, unboundedDelays
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.8.1.3";
  sha256 = "0hc030ms89w3cl1k3r8nrym3g7sg2n66ch2ljg6d7fwhrsgxnagf";
  buildDepends = [
    ansiTerminal async deepseq mtl optparseApplicative regexTdfaRc stm
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
