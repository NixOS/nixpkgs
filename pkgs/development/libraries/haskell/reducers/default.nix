{ cabal, comonad, fingertree, hashable, keys, pointed
, semigroupoids, semigroups, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "reducers";
  version = "3.10.1";
  sha256 = "0pgywdgq0rqir95n4z3nzmyx5n54a1df9abyanz4qfv0g080fjkz";
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
