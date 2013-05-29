{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "process-leksah";
  version = "1.0.1.4";
  sha256 = "1899ybhnsj22sir2l933lhkk9fpcgjbb4qd6gscnby28qcs5bwbv";
  buildDepends = [ filepath ];
  meta = {
    description = "Process libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
