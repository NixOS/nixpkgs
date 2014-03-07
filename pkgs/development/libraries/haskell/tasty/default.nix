{ cabal, ansiTerminal, async, deepseq, mtl, optparseApplicative
, regexTdfa, stm, tagged, unboundedDelays
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.8";
  sha256 = "12r8ml45r1dq3vmjkibxkla5rmmyrm11js26kmkha110ji8hnflg";
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
