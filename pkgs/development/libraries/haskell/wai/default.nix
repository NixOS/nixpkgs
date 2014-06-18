{ cabal, blazeBuilder, hspec, httpTypes, network, text, vault }:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "3.0.0.1";
  sha256 = "1f8alq4lygjdb4pzb7xm6jml3dviygk18siwfwb751va3j2fmi0v";
  buildDepends = [ blazeBuilder httpTypes network text vault ];
  testDepends = [ blazeBuilder hspec ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Web Application Interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
