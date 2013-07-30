{ cabal, monoidExtras, newtype, semigroups }:

cabal.mkDerivation (self: {
  pname = "dual-tree";
  version = "0.1.0.3";
  sha256 = "0k3p1lqhynlqvkbnrs5vn478c76qcn754n5pb17p5i4jcw94bm0n";
  buildDepends = [ monoidExtras newtype semigroups ];
  jailbreak = true;
  meta = {
    description = "Rose trees with cached and accumulating monoidal annotations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
