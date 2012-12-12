{ cabal, lens, newtype, vectorSpace, vectorSpacePoints }:

cabal.mkDerivation (self: {
  pname = "force-layout";
  version = "0.2";
  sha256 = "0aif7a28qs8ya7q9sklp02gb5228jyj8k4jabbp2sia7j4khrkpv";
  buildDepends = [ lens newtype vectorSpace vectorSpacePoints ];
  meta = {
    description = "Simple force-directed layout";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
