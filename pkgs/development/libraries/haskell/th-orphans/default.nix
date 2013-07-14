{ cabal, thLift }:

cabal.mkDerivation (self: {
  pname = "th-orphans";
  version = "0.7";
  sha256 = "0fb0wkpvb8wc12gpgm90jfsgcm4p1wf8p0m5xjk64zkcjrdxjr80";
  buildDepends = [ thLift ];
  noHaddock = true;
  meta = {
    description = "Orphan instances for TH datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
