{ cabal, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.2.2.1";
  sha256 = "0n2zwkwwq8kg9m6qr79mrhlxsfsrjzbyg96gfhcgk21zgc09zary";
  buildDepends = [ semigroups ];
  jailbreak = true;
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
