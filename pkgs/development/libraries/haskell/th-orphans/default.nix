{ cabal, thLift }:

cabal.mkDerivation (self: {
  pname = "th-orphans";
  version = "0.7.0.1";
  sha256 = "19lfq2m7c6n2z8gz4n57wc92x5x5rkgv4chbfq7w4n531qya4bgr";
  buildDepends = [ thLift ];
  meta = {
    description = "Orphan instances for TH datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
