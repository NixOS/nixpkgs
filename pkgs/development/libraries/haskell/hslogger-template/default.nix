{ cabal, hslogger, mtl }:

cabal.mkDerivation (self: {
  pname = "hslogger-template";
  version = "2.0.1";
  sha256 = "1m8h4i8cxxw83vhbw61njvv86qdcff6zi3bf0nyhc4cq7pfrzqvj";
  buildDepends = [ hslogger mtl ];
  meta = {
    description = "Automatic generation of hslogger functions";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
