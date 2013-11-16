{ cabal, ansiTerminal, deepseq, mtl, optparseApplicative
, regexPosix, stm, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.4.0.1";
  sha256 = "04nnjg04520lvjm8h2ma0ihm4bz6p0ppk445i8gmn82ixwan76h0";
  buildDepends = [
    ansiTerminal deepseq mtl optparseApplicative regexPosix stm tagged
  ];
  meta = {
    description = "Modern and extensible testing framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
