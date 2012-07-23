{ cabal, comonad, contravariant, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "semigroupoids";
  version = "1.3.4";
  sha256 = "0vnipjndbsldk5w1qw35i2zrd418rq13y10g0i33ylg1gwnsrqph";
  buildDepends = [ comonad contravariant semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/semigroupoids";
    description = "Haskell 98 semigroupoids: Category sans id";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
