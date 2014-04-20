{ cabal }:

cabal.mkDerivation (self: {
  pname = "graph-wrapper";
  version = "0.2.4.2";
  sha256 = "0cf70xvmzn4w5pg1bxizajqgcbjwwk6jrd7hnb3kfqy1v3apifyf";
  meta = {
    homepage = "http://www.github.com/batterseapower/graph-wrapper";
    description = "A wrapper around the standard Data.Graph with a less awkward interface";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
