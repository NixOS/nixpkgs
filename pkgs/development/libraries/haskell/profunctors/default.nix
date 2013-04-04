{ cabal, comonad, tagged }:

cabal.mkDerivation (self: {
  pname = "profunctors";
  version = "3.3.0.1";
  sha256 = "16d7xg929r4smmmcgi54bz7rsjxs6psksrdvzl4336sjpp3dw5h2";
  buildDepends = [ comonad tagged ];
  meta = {
    homepage = "http://github.com/ekmett/profunctors/";
    description = "Haskell 98 Profunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
