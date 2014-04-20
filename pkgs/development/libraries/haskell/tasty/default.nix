{ cabal, ansiTerminal, async, deepseq, mtl, optparseApplicative
, regexTdfa, stm, tagged, unboundedDelays
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.8.0.4";
  sha256 = "016niwympxbxpg3yq7samgh92l20wxm2h6cwhqal4zdj8n9262j0";
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
