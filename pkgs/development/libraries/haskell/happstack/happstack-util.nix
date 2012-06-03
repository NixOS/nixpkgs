{ cabal, extensibleExceptions, filepath, hslogger, mtl, network
, parsec, random, time, unixCompat
}:

cabal.mkDerivation (self: {
  pname = "happstack-util";
  version = "6.0.3";
  sha256 = "0hqssd5wzir6rxn46q8r3hdp3nl7v5m7w322j39120xpg2bhiphh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    extensibleExceptions filepath hslogger mtl network parsec random
    time unixCompat
  ];
  patchPhase = ''
    sed -i -e 's|mtl >= 1.1 && < 2.1|mtl|' happstack-util.cabal
  '';
  meta = {
    homepage = "http://happstack.com";
    description = "Web framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
