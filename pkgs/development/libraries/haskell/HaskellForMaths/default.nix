{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "HaskellForMaths";
  version = "0.4.4";
  sha256 = "1qijaich0jwlii5wdmv0rnr6skbyacxg09nzh0i7dhk86vimz6q8";
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
