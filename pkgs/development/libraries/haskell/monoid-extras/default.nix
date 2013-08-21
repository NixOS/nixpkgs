{ cabal, semigroupoids, semigroups }:

cabal.mkDerivation (self: {
  pname = "monoid-extras";
  version = "0.3.1.0";
  sha256 = "0nxdkx0j67nb41ingp1yl0appfx64ikf5709f48469qbaf3pgax3";
  buildDepends = [ semigroupoids semigroups ];
  meta = {
    description = "Various extra monoid-related definitions and utilities";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
