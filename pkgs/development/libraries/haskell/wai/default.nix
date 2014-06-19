{ cabal, blazeBuilder, hspec, httpTypes, network, text, vault }:

cabal.mkDerivation (self: {
  pname = "wai";
  version = "3.0.0.2";
  sha256 = "1zmpalgck8jns45wnlarw26kfw45ml0cp82kdqqpbckscxnr04r1";
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
