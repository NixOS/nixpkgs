{ cabal, groups, semigroupoids, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.3.3.3";
  sha256 = "0i4c2yn0kbkqi478x93r2xvl05l4r3x7nyjd47zy3r4bb38qwj89";
  buildDepends = [ groups semigroupoids semigroups ];
  jailbreak = true;
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
