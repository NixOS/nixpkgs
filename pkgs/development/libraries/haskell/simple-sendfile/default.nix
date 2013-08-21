{ cabal, conduit, hspec, HUnit, network, networkConduit }:

cabal.mkDerivation (self: {
  pname = "simple-sendfile";
  version = "0.2.12";
  sha256 = "019n82700fbhsqxgn1cwfqii27r436gljis7yl02zjnzy7xlvrha";
  buildDepends = [ network ];
  testDepends = [ conduit hspec HUnit network networkConduit ];
  doCheck = false;
  meta = {
    description = "Cross platform library for the sendfile system call";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
