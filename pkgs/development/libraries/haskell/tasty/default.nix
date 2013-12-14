{ cabal, ansiTerminal, deepseq, mtl, optparseApplicative
, regexPosix, stm, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.5.2";
  sha256 = "0zj6bpqld04sivfkpzjp2c587mmygl3699znqmhp1dbv0fpq6949";
  buildDepends = [
    ansiTerminal deepseq mtl optparseApplicative regexPosix stm tagged
  ];
  meta = {
    description = "Modern and extensible testing framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
