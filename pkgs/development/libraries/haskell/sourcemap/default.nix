{ cabal, aeson, attoparsec, text, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "sourcemap";
  version = "0.1.2.0";
  sha256 = "040j2k1cwzlq5pybs6cg7wmf0x5i22zdidv2xvzdvgi5v7gf6kp1";
  buildDepends = [
    aeson attoparsec text unorderedContainers utf8String
  ];
  meta = {
    description = "Implementation of source maps as proposed by Google and Mozilla";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
