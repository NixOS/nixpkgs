{ cabal }:

cabal.mkDerivation (self: {
  pname = "heredoc";
  version = "0.2.0.0";
  sha256 = "0h0g2f7yscwl1ba1yn3jnz2drvd6ns9m910hwlmq3kdq3k39y3f9";
  meta = {
    homepage = "http://hackage.haskell.org/package/heredoc";
    description = "multi-line string / here document using QuasiQuotes";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
