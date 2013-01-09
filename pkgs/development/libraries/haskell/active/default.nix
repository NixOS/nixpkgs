{ cabal, newtype, semigroupoids, semigroups, vectorSpace }:

cabal.mkDerivation (self: {
  pname = "active";
  version = "0.1.0.2";
  sha256 = "1iymh3sd21ba7ijwv5afphn5vhmwchk6725hbcsdwk2d2x2gd674";
  buildDepends = [ newtype semigroupoids semigroups vectorSpace ];
  jailbreak = true;
  meta = {
    description = "Abstractions for animation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
