{ cabal, comonad, fingertree, hashable, keys, pointed
, semigroupoids, semigroups, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "reducers";
  version = "3.0.2";
  sha256 = "0inw5gz3bdrfc6hprjfxssyqjwmclgf09gms14blj24qr027gdqq";
  buildDepends = [
    comonad fingertree hashable keys pointed semigroupoids semigroups
    text transformers unorderedContainers
  ];
  meta = {
    homepage = "http://github.com/ekmett/reducers/";
    description = "Semigroups, specialized containers and a general map/reduce framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
