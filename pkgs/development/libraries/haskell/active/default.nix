{ cabal, newtype, semigroupoids, semigroups, vectorSpace }:

cabal.mkDerivation (self: {
  pname = "active";
  version = "0.1.0.3";
  sha256 = "0jarc270z6raak1vz30jy2gl0pkj9a2x3ib5hq7vsl2ljbvbgyqi";
  buildDepends = [ newtype semigroupoids semigroups vectorSpace ];
  jailbreak = true;
  meta = {
    description = "Abstractions for animation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
