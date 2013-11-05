{ cabal, free, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-parse";
  version = "2.0.2";
  sha256 = "1jcws5i9jhh4i6bh2j6m9pz1462qm05byibkkxfqvyx392sxy4wz";
  buildDepends = [ free pipes transformers ];
  meta = {
    description = "Parsing infrastructure for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
