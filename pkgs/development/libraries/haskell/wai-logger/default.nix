{ cabal, blazeBuilder, byteorder, caseInsensitive, dateCache
, doctest, fastLogger, httpTypes, network, wai, waiTest
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "0.3.2";
  sha256 = "0las9jb8cxdsyh1mnrhx48yfbjw5f2x4hhmivhmhzb6qgxnbvma9";
  buildDepends = [
    blazeBuilder byteorder caseInsensitive dateCache fastLogger
    httpTypes network wai
  ];
  testDepends = [ doctest waiTest ];
  meta = {
    description = "A logging system for WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
