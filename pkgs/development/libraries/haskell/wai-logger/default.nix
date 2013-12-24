{ cabal, blazeBuilder, byteorder, caseInsensitive, doctest
, fastLogger, httpTypes, network, unixTime, wai, waiTest
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "2.0.2";
  sha256 = "0wpx01sizl17ln1npia1c9hx1ph5qv8zwmikgmv0hkgx7w9bifaa";
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
