{ cabal, aeson, alex, ansiTerminal, attoparsec, base64Bytestring
, blazeHtml, blazeMarkup, dataDefault, Diff, extensibleExceptions
, filepath, happy, highlightingKate, hslua, HTTP, httpConduit
, httpTypes, HUnit, mtl, network, pandocTypes, parsec, QuickCheck
, random, stringable, syb, tagsoup, temporary, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, texmath, text, time
, unorderedContainers, vector, xml, yaml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.12";
  sha256 = "04jng6mrb78gzksspihkcmiidrjyqya06lnqiwvfq7mk9jd1wy49";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson alex attoparsec base64Bytestring blazeHtml blazeMarkup
    dataDefault extensibleExceptions filepath happy highlightingKate
    hslua HTTP httpConduit httpTypes mtl network pandocTypes parsec
    random stringable syb tagsoup temporary texmath text time
    unorderedContainers vector xml yaml zipArchive zlib
  ];
  testDepends = [
    ansiTerminal Diff filepath highlightingKate HUnit pandocTypes
    QuickCheck syb testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text
  ];
  doCheck = false;
  meta = {
    homepage = "http://johnmacfarlane.net/pandoc";
    description = "Conversion between markup formats";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
