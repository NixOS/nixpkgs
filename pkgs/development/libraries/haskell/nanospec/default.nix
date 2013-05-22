{ cabal, hspec, silently }:

cabal.mkDerivation (self: {
  pname = "nanospec";
  version = "0.1.0";
  sha256 = "16qpn199p8nrllg800zryhb8795jgk78znng5fjq1raj8l3snjk0";
  testDepends = [ hspec silently ];
  doCheck = false;
  meta = {
    description = "A lightweight implementation of a subset of Hspec's API";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
