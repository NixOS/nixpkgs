{ cabal, ansiTerminal, base64Bytestring, blazeHtml, blazeMarkup
, citeprocHs, dataDefault, Diff, extensibleExceptions, filepath
, highlightingKate, HTTP, HUnit, json, mtl, network, pandocTypes
, parsec, QuickCheck, random, syb, tagsoup, temporary
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
, texmath, text, time, xml, zipArchive, zlib
}:

cabal.mkDerivation (self: {
  pname = "pandoc";
  version = "1.11.1";
  sha256 = "0b23vrgkm1csykx1zrldkg5ka816j6m7a5fhs4cxffalifq91c7b";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    base64Bytestring blazeHtml blazeMarkup citeprocHs dataDefault
    extensibleExceptions filepath highlightingKate HTTP json mtl
    network pandocTypes parsec random syb tagsoup temporary texmath
    text time xml zipArchive zlib
  ];
  testDepends = [
    ansiTerminal Diff filepath highlightingKate HUnit pandocTypes
    QuickCheck syb testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text
  ];
  configureFlags = "-fblaze_html_0_5";
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
