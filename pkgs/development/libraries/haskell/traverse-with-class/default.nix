{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "traverse-with-class";
  version = "0.1.1.1";
  sha256 = "0agdgnibv8q65av2fkr2qm0air8zqmygwpkl30wmay5mqqknzxiq";
  buildDepends = [ transformers ];
  meta = {
    description = "Generic applicative traversals";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
