{ cabal, exceptions, free, monadControl, MonadRandom, mtl
, semigroupoids, semigroups, transformers, transformersBase
}:

cabal.mkDerivation (self: {
  pname = "either";
  version = "4.3.0.1";
  sha256 = "1ib6288gxzqfm2y198dzhhq588mlwqxm07pcrj4h66g1mcy54q1f";
  buildDepends = [
    exceptions free monadControl MonadRandom mtl semigroupoids
    semigroups transformers transformersBase
  ];
  noHaddock = self.stdenv.lib.versionOlder self.ghc.version "7.6";
  meta = {
    homepage = "http://github.com/ekmett/either/";
    description = "An either monad transformer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
