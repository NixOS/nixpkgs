{ cabal, exceptions, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-safe";
  version = "2.0.0";
  sha256 = "1g7ha6x87qyk3f9vrl0djzdvaq80q4q6hh7lya4kgm3cbz00a0yv";
  buildDepends = [ exceptions pipes transformers ];
  meta = {
    description = "Safety for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
