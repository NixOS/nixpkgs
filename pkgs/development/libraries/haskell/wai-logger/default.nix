{ cabal, blazeBuilder, byteorder, caseInsensitive, dateCache
, fastLogger, httpTypes, network, wai
}:

cabal.mkDerivation (self: {
  pname = "wai-logger";
  version = "0.3.0";
  sha256 = "132jcjyqr7bxcfi7v9mapvx8dci0lz8rv91mgnrzgvpac542c2yq";
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
