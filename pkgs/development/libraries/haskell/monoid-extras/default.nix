{ cabal, groupoids, groups, semigroupoids, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.3.3";
  sha256 = "1a203fccwfmyqdv9mdzwd6gq5g9v3k9mial8n0hykdhmlny7dd56";
  buildDepends = [ groupoids groups semigroupoids semigroups ];
  jailbreak = true;
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
