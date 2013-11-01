{ cabal, groupoids, groups, semigroupoids, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.3.2.3";
  sha256 = "1q7aw4adg082rszkc3skdvidcn86n06xvr3x8qarpjb285znsmc4";
  buildDepends = [ groupoids groups semigroupoids semigroups ];
  jailbreak = true;
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
