{ cabal, filepath, languageCQuote, mainlandPretty }:

cabal.mkDerivation (self: {
  pname = "language-c-inline";
  version = "0.3.0.1";
  sha256 = "0dw1fqwg9hhwgvak0ykhafbxp4gnb2ww9lc83m8kzkyzn1ccb6hg";
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
