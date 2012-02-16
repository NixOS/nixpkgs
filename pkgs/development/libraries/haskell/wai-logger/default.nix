{ cabal, blazeBuilder, byteorder, caseInsensitive, fastLogger
, httpTypes, network, time, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "0.1.4";
  sha256 = "1rvcqq4jlkcjavy8a3vf61jclwpnjmj6cp3whrzwvay9b1qfsck3";
  buildDepends = [
    blazeBuilder byteorder caseInsensitive fastLogger httpTypes network
    time wai
  ];
  meta = {
    description = "A logging system for WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
