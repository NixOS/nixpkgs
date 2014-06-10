{ cabal, blazeBuilder, hspec, httpTypes, network, text, vault }:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "3.0.0";
  sha256 = "0zzcyrr0pkj439n28wmivmfavh9cdjc1mz3zrbi88zmrzg4wpssx";
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
