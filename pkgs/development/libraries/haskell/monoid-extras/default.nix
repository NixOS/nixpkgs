{ cabal, groupoids, groups, semigroupoids, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.3.2.2";
  sha256 = "1fy0fk2mzan6n5chc11x303hz3iq3kpx6ma6c8xsi8va1b9ikpda";
  buildDepends = [ groupoids groups semigroupoids semigroups ];
  jailbreak = true;
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
