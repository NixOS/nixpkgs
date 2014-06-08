{ cabal, monadControl, MonadRandom, mtl, semigroupoids, semigroups
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "either";
  version = "4.1.2";
  sha256 = "1c2dp22al9qq2w1xks5s3n8dcan9wpashvn24i4g8avs8yfrr5v4";
  buildDepends = [
    monadControl MonadRandom mtl semigroupoids semigroups transformers
    transformersBase
  ];
  noHaddock = self.stdenv.lib.versionOlder self.ghc.version "7.6";
  meta = {
    homepage = "http://github.com/ekmett/either/";
    description = "An either monad transformer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
