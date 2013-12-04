{ cabal, ansiTerminal, deepseq, mtl, optparseApplicative
, regexPosix, stm, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.4.1.1";
  sha256 = "09xha87ivkllczbf0vf2n8zjn1wa5g8v8j1h9ad3207r45ndzn0w";
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
