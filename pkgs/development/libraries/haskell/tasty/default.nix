{ cabal, ansiTerminal, deepseq, mtl, optparseApplicative
, regexPosix, stm, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.4.2";
  sha256 = "06348zdagaxk0axdmfj38r2h6pcacr0kqwx6hz6f499xdj8g74g9";
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
