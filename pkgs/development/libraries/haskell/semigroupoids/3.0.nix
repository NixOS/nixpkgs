{ cabal, comonad, contravariant, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "semigroupoids";
  version = "3.0";
  sha256 = "0wsax14ck363nby0xrhcpvdzf0pzspayl7gsm0br0lr6ipmpcrag";
  buildDepends = [ comonad contravariant semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/semigroupoids";
    description = "Haskell 98 semigroupoids: Category sans id";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
