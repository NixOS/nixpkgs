{ cabal, groupoids, groups, semigroupoids, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.3.2.4";
  sha256 = "1qrgwnczznjp1visspqf3dk224nvqf5icv3646j96acl5srn84qc";
  buildDepends = [ groupoids groups semigroupoids semigroups ];
  jailbreak = true;
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
