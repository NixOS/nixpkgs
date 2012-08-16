{ cabal, blazeBuilder, byteorder, caseInsensitive, fastLogger
, httpTypes, network, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "0.2.0";
  sha256 = "1p89k71y0y5kpvy9iniqfyz3wmaw1q75s2324df1m1w1hcc0lgb6";
  buildDepends = [
    blazeBuilder byteorder caseInsensitive fastLogger httpTypes network
    wai
  ];
  meta = {
    description = "A logging system for WAI";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
