{ cabal, filepath, languageCQuote, mainlandPretty }:

cabal.mkDerivation (self: {
  pname = "language-c-inline";
  version = "0.5.0.0";
  sha256 = "1cyl45bi2d38yyd1ybxippl8mv3hsl1chzn7rqm40fds97h07j2z";
  buildDepends = [ filepath languageCQuote mainlandPretty ];
  testDepends = [ languageCQuote ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/mchakravarty/language-c-inline/";
    description = "Inline C & Objective-C code in Haskell for language interoperability";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
