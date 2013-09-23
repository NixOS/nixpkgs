{ cabal, groupoids, groups, semigroupoids, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.3.2.0";
  sha256 = "0yhb55v0a2221xbpbm8jiqzqvps0lab5n8iakpq69ndr2l0d2r3x";
  buildDepends = [ groupoids groups semigroupoids semigroups ];
  jailbreak = true;
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
