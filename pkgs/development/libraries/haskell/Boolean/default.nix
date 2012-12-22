{ cabal }:

cabal.mkDerivation (self: {
  pname = "Boolean";
  version = "0.1.1";
  sha256 = "1id075slxgz67gv382vpr7cr19i59bjajvb60iv2xrhh73gp08yv";
  meta = {
    description = "Generalized booleans";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
