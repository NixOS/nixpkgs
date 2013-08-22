{ cabal, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.3.0.0";
  sha256 = "1bb8yq2vja80177h3wfadkjkwvcrszx0nq6m5n10f4lh9spvr087";
  buildDepends = [ semigroups ];
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
