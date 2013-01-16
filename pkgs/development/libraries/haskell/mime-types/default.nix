{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "mime-types";
  version = "0.1.0.2";
  sha256 = "1pkhr8k23386qwa1wmlrcilz75di2l8n5kc4n8pnia05p49akfcs";
  buildDepends = [ text ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Basic mime-type handling types and functions";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
