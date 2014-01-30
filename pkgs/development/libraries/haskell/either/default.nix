{ cabal, monadControl, MonadRandom, mtl, semigroupoids, semigroups
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "either";
  version = "4.1";
  sha256 = "1wddidjqwk283zrydl6xwi0crrrlskayici0fhjyf2abd3lgnnkc";
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
