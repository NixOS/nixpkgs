{ cabal, Cabal, extensibleExceptions, filepath, hslogger, mtl
, network, parsec, random, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "happstack-util";
  version = "6.0.3";
  sha256 = "0hqssd5wzir6rxn46q8r3hdp3nl7v5m7w322j39120xpg2bhiphh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal extensibleExceptions filepath hslogger mtl network parsec
    random time unixCompat
  ];
  meta = {
    homepage = "http://happstack.com";
    description = "Web framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
