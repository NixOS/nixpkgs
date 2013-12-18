{ cabal, comonad, fingertree, hashable, keys, pointed
, semigroupoids, semigroups, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "reducers";
  version = "3.10.1.1";
  sha256 = "1d4zhcqy499pm0wxn76gyw0brbrdycmajblqy4mi49kiy0zlg8a7";
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
