{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "HaskellForMaths";
  version = "0.4.5";
  sha256 = "03j83gvxjjqjwl047j0acsf9j5vs3zpzbap036sw4slq31nza2p9";
  buildDepends = [ random ];
  meta = {
    homepage = "http://haskellformaths.blogspot.com/";
    description = "Combinatorics, group theory, commutative algebra, non-commutative algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
