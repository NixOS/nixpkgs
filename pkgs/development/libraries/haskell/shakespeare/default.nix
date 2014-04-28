{ cabal, aeson, blazeHtml, blazeMarkup, exceptions, hspec, HUnit
, parsec, systemFileio, systemFilepath, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "2.0.0.3";
  sha256 = "12dmhcv404bh7kn04d175bj2b0fadz4sjypwsq151mlhakr13x85";
  buildDepends = [
    aeson blazeHtml blazeMarkup exceptions parsec systemFileio
    systemFilepath text time transformers
  ];
  testDepends = [
    aeson blazeHtml blazeMarkup exceptions hspec HUnit parsec
    systemFileio systemFilepath text time transformers
  ];
  meta = {
    homepage = "http://www.yesodweb.com/book/shakespearean-templates";
    description = "A toolkit for making compile-time interpolated templates";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
