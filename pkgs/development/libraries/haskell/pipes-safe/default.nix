{ cabal, exceptions, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-safe";
  version = "2.0.2";
  sha256 = "004xjf0aqa73gxn8kj9844pwbkriv3hk9sbnwxx26pgvqvwjlrsj";
  buildDepends = [ exceptions pipes transformers ];
  meta = {
    description = "Safety for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
