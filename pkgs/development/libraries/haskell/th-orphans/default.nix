{ cabal, thLift }:

cabal.mkDerivation (self: {
  pname = "th-orphans";
  version = "0.8";
  sha256 = "0kzzcicn6pggvvblhbrs3vh0bf71izlb99lb0f5qww7ymi4smldr";
  buildDepends = [ thLift ];
  meta = {
    description = "Orphan instances for TH datatypes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
