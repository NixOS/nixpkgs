{ cabal, semigroupoids, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "either";
  version = "3.0.2";
  sha256 = "1s3rpxxqc9052hrmiznwqwxhl4826qzbgpivpv5acxfhm0w06lhg";
  buildDepends = [ semigroupoids semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/either/";
    description = "Haskell 98 either monad transformer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
