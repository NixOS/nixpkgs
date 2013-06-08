{ cabal, comonad, contravariant, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "semigroupoids";
  version = "3.0.2";
  sha256 = "0k137iafw0srgmy4qwx3cbx00519c0h91nmszdbx6pzpvf6m5fwm";
  buildDepends = [ comonad contravariant semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/semigroupoids";
    description = "Haskell 98 semigroupoids: Category sans id";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
