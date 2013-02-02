{ cabal, semigroupoids, semigroups, tagged }:

cabal.mkDerivation (self: {
  pname = "bifunctors";
  version = "3.2";
  sha256 = "03bszf1127iw5kimjbag5gmgzz7h2qzcd9f7jb53jpiadfhjfx0a";
  buildDepends = [ semigroupoids semigroups tagged ];
  meta = {
    homepage = "http://github.com/ekmett/bifunctors/";
    description = "Haskell 98 bifunctors";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
