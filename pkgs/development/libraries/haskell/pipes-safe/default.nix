{ cabal, exceptions, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-safe";
  version = "2.1.0";
  sha256 = "0qm02hwmrqlncnlxix7mdgzbf0mzally4k7ydwg06nqi35bb7s3j";
  buildDepends = [ exceptions pipes transformers ];
  meta = {
    description = "Safety for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
