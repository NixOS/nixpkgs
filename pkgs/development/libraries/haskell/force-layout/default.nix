{ cabal, lens, newtype, vectorSpace, vectorSpacePoints }:

cabal.mkDerivation (self: {
  pname = "force-layout";
  version = "0.2.0.1";
  sha256 = "1fvkfgjwsh0cr6ay4djxc8wg0vqfw2vcq3clqjz0zi8zyyjpv8rx";
  buildDepends = [ lens newtype vectorSpace vectorSpacePoints ];
  meta = {
    description = "Simple force-directed layout";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
