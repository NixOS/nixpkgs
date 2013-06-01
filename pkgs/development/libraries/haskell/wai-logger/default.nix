{ cabal, blazeBuilder, byteorder, caseInsensitive, dateCache
, fastLogger, httpTypes, network, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "0.3.1";
  sha256 = "0x1d67fcfpjrgyjr7hipifqrzk13x8z8xmlj7h999r8mswijhgii";
  buildDepends = [
    blazeBuilder byteorder caseInsensitive dateCache fastLogger
    httpTypes network wai
  ];
  meta = {
    description = "A logging system for WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
