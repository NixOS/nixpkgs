{ cabal, hslogger, mtl }:

cabal.mkDerivation (self: {
  pname = "hslogger-template";
  version = "2.0.2";
  sha256 = "0qkyclj9fajvzbfcs0ik8ncy66x916r40jd85r4wi5nh482i7sp3";
  buildDepends = [ hslogger mtl ];
  meta = {
    description = "Automatic generation of hslogger functions";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
