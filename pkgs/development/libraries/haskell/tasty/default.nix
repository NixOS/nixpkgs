{ cabal, ansiTerminal, async, deepseq, mtl, optparseApplicative
, regexTdfa, stm, tagged, unboundedDelays
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.8.1.2";
  sha256 = "07pxnm9cx28vlfypa4psnnxcfx1i4qwimkf0nkfzqkhzqb85a58s";
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
