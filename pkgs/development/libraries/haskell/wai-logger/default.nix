{ cabal, blazeBuilder, byteorder, caseInsensitive, doctest
, fastLogger, httpTypes, network, unixTime, wai, waiTest
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "2.1.0";
  sha256 = "1vb2nih78qw7ha1v67hsyyplarxxg5zh82pmh85sdbdykp5cwz0c";
  buildDepends = [
    blazeBuilder byteorder caseInsensitive fastLogger httpTypes network
    unixTime wai
  ];
  testDepends = [ doctest waiTest ];
  meta = {
    description = "A logging system for WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
