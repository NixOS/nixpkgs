{ cabal, blazeBuilder, byteorder, caseInsensitive, fastLogger
, httpTypes, network, time, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "0.1.1";
  sha256 = "02354n4j1wj2n2vn4hza7ng2gqbf6ibvr4gfnv7maisivgqjy694";
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
