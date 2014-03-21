{ cabal, groups, semigroupoids, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.3.3.1";
  sha256 = "1176sazk10vapia1qvcm2rxckn2vxfav21277rsgf11hvn3lzznc";
  buildDepends = [ groups semigroupoids semigroups ];
  jailbreak = true;
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
