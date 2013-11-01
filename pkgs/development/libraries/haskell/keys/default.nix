{ cabal, comonad, free, semigroupoids, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "keys";
  version = "3.10";
  sha256 = "1s2xkzvaqk507wrgabpxli8g8n83arflmdhxq40f7qkvyflhhmyh";
  buildDepends = [
    comonad free semigroupoids semigroups transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/keys/";
    description = "Keyed functors and containers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
