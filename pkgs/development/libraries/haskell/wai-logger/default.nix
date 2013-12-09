{ cabal, blazeBuilder, byteorder, caseInsensitive, doctest
, fastLogger, httpTypes, network, unixTime, wai, waiTest
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "2.0.1";
  sha256 = "1v8n7m314a12421gn10i8vz3nk9sak635dq4nq389sij8w1ihjkw";
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
