{ cabal, blazeBuilder, conduit, httpTypes, network, text
, transformers, vault
}:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "1.2.0.1";
  sha256 = "00f95r1g2s689s1b0div28v7dnjiqz01d66acz77acp28cm0bnmc";
  buildDepends = [
    blazeBuilder conduit httpTypes network text transformers vault
  ];
  meta = {
    homepage = "https://github.com/yesodweb/wai";
    description = "Web Application Interface";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
