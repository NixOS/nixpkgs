{ cabal, aeson, blazeHtml, blazeMarkup, exceptions, hspec, HUnit
, parsec, systemFileio, systemFilepath, text, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "shakespeare";
  version = "2.0.1";
  sha256 = "1h1b7p4czdzrxb77515vqnck3rj3yw35h2ds6gzxzp7pdxprds27";
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
