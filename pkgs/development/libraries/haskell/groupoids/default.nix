{ cabal, semigroupoids }:

cabal.mkDerivation (self: {
  pname = "groupoids";
  version = "3.0.1.1";
  sha256 = "0r4xjyq7icd52nas27bhr5k8q7li6lba8mlkcipghhsgxsyjfp63";
  buildDepends = [ semigroupoids ];
  meta = {
    homepage = "http://github.com/ekmett/groupoids/";
    description = "Haskell 98 Groupoids";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
