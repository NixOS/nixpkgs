{ cabal, monadControl, MonadRandom, mtl, semigroupoids, semigroups
, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "either";
  version = "4.1.1";
  sha256 = "0wipgwrca7bm4rm843gc0p69f2hvm2z067mjrv8qvnivyxhy8i6k";
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
