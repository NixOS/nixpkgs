{ cabal, blazeBuilder, byteorder, caseInsensitive, fastLogger
, httpTypes, network, time, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "0.1.2";
  sha256 = "0pzbdjy0xkjqkzc5w1v0hh18jgbxlkllsjwxabswkh8gl73mp7d9";
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
