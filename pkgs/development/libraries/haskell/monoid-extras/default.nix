{ cabal, groups, semigroupoids, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.3.3.2";
  sha256 = "0v4xir47ki83f9w2rii06w3jwrvqljnbiivgh6k8jxl0bdfslh11";
  buildDepends = [ groups semigroupoids semigroups ];
  jailbreak = true;
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
