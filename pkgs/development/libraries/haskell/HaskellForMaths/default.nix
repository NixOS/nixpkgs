{ cabal, random }:

cabal.mkDerivation (self: {
  pname = "HaskellForMaths";
  version = "0.4.3";
  sha256 = "00s502h3pw9i464qn6cn74ihghcnn5gsar891q276ld682m5vdns";
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
