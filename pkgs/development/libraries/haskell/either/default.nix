{ cabal, semigroupoids, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "either";
  version = "3.0.3";
  sha256 = "02kpb8xd19n00ll61haqr6k3hy8qmbdf73gr4zs59q9xh0739qxc";
  buildDepends = [ semigroupoids semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/either/";
    description = "Haskell 98 either monad transformer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
