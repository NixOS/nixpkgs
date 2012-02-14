{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "xhtml";
  version = "3000.2.0.1";
  sha256 = "15pcigascajky67v0lhdhn4bv8xq16cvzib05mg4f1ynwr5a9mv0";
  buildDepends = [ Cabal ];
  meta = {
    description = "An XHTML combinator library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
