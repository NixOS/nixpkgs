{ cabal, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.2.2.2";
  sha256 = "1fz93hm0sswisvwvbygxvbwmmnzqcxmz9h82i4361wzychf2si22";
  buildDepends = [ semigroups ];
  jailbreak = true;
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
