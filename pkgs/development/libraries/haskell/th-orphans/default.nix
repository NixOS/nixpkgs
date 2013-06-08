{ cabal, thLift }:

cabal.mkDerivation (self: {
  pname = "th-orphans";
  version = "0.6";
  sha256 = "1ablf4c8vp9kzvr75ngl5yz3ip5klk6zmq7bcqcvks758b9c6qgj";
  buildDepends = [ thLift ];
  noHaddock = true;
  meta = {
    description = "Orphan instances for TH datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
