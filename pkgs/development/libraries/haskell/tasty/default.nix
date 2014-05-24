{ cabal, ansiTerminal, async, deepseq, mtl, optparseApplicative
, regexTdfa, stm, tagged, unboundedDelays
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.8.1.1";
  sha256 = "04vzq5gwyd5zb6lsf8nbr5dypgf07b4aq70i1jghkg12v8h529dr";
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
