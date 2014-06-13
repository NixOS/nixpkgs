{ cabal, blazeBuilder, byteorder, caseInsensitive, doctest
, fastLogger, httpTypes, network, unixTime, wai, waiTest
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "2.1.1";
  sha256 = "1cdl5nglb8jghi0yndpabraihgh681m5q1j77wsxzckxisga73j8";
  buildDepends = [
    blazeBuilder byteorder caseInsensitive fastLogger httpTypes network
    unixTime wai
  ];
  testDepends = [ doctest waiTest ];
  doCheck = false;
  meta = {
    description = "A logging system for WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
