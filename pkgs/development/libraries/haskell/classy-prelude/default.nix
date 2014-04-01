{ cabal, basicPrelude, chunkedData, enclosedExceptions, hashable
, hspec, liftedBase, monoTraversable, QuickCheck, semigroups
, systemFilepath, text, time, transformers, unorderedContainers
, vector, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.8.2";
  sha256 = "1kvab1vns1mp0i0nyn0flg2m6f2sl8w1yr2c0x54172f20rdm5lv";
  buildDepends = [
    basicPrelude chunkedData enclosedExceptions hashable liftedBase
    monoTraversable semigroups systemFilepath text time transformers
    unorderedContainers vector vectorInstances
  ];
  testDepends = [
    hspec QuickCheck transformers unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
