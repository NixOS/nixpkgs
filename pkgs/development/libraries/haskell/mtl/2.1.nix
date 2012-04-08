{ cabal, transformers }:

cabal.mkDerivation (self: {
  pname = "mtl";
  version = "2.1";
  sha256 = "041fhi6vgddj43y26ljhxqjryjbsj0rb6m6gfpvrjynzp6c7c5n6";
  buildDepends = [ transformers ];
  meta = {
    description = "Monad classes, using functional dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
