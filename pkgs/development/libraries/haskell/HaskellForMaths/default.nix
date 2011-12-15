{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "HaskellForMaths";
  version = "0.4.1";
  sha256 = "0jwdxz5wqayx196giv7nj5j0k9zw50x555ig6xj00cladvplvh9h";
  buildDepends = [ random ];
  meta = {
    homepage = "http://haskellformaths.blogspot.com/";
    description = "Combinatorics, group theory, commutative algebra, non-commutative algebra";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
