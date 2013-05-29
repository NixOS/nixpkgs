{ cabal, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.2.2.3";
  sha256 = "00yj7wdyznsis82fb7i07s0vz8vsn2mpqk7jkgl9xxa57gk1rsax";
  buildDepends = [ semigroups ];
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
