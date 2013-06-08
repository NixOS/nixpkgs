{ cabal, hspec, systemFilepath, text }:

cabal.mkDerivation (self: {
  pname = "ReadArgs";
  version = "1.2.1";
  sha256 = "099gg6nq70yf2pl5ya8f083lw8x5rncnv54y2p5jlkdwfwmpmbnv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ systemFilepath text ];
  testDepends = [ hspec systemFilepath text ];
  meta = {
    homepage = "http://github.com/rampion/ReadArgs";
    description = "Simple command line argument parsing";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
