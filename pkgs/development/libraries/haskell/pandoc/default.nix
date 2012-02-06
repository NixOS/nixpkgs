{ cabal, ansiTerminal, base64Bytestring, blazeHtml, citeprocHs
, Diff, extensibleExceptions, highlightingKate, HTTP, HUnit, json
, mtl, network, pandocTypes, parsec, QuickCheck, random, syb
, tagsoup, temporary, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, texmath, time, utf8String, xml
, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.9.0.3";
  sha256 = "1p5054sdvvgl38rr0ajfavr79rwr2l8jdrpzai329ksskkh1acdp";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal base64Bytestring blazeHtml citeprocHs Diff
    extensibleExceptions highlightingKate HTTP HUnit json mtl network
    pandocTypes parsec QuickCheck random syb tagsoup temporary
    testFramework testFrameworkHunit testFrameworkQuickcheck2 texmath
    time utf8String xml zipArchive zlib
  ];
  configureFlags = "-fhighlighting -fthreaded";
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
