{ cabal, bifunctors, comonad, distributive, mtl, preludeExtras
, profunctors, semigroupoids, semigroups, transformers
}:

cabal.mkDerivation (self: {
  pname = "free";
  version = "4.9";
  sha256 = "01pa9ax9i4pkh9a5achndx5s7sxvhnk6rm57g8rzav79hzsr4cnx";
  buildDepends = [
    bifunctors comonad distributive mtl preludeExtras profunctors
    semigroupoids semigroups transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/ekmett/free/";
    description = "Monads for free";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
