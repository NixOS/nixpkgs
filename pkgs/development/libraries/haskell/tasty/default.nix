{ cabal, ansiTerminal, deepseq, mtl, optparseApplicative
, regexPosix, stm, tagged
}:

cabal.mkDerivation (self: {
  pname = "tasty";
  version = "0.5.2.1";
  sha256 = "0dph1c0j2vjvzf5csp6hwlcx2zqa12yqrafk6pxs8bnd3r9a11ym";
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
