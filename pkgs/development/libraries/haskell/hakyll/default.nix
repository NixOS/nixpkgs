{ cabal, binary, blazeHtml, blazeMarkup, pandocCiteproc, cmdargs
, cryptohash, dataDefault, deepseq, filepath, fsnotify, httpConduit
, httpTypes, HUnit, lrucache, mtl, network, pandoc, parsec
, QuickCheck, random, regexBase, regexTdfa, snapCore, snapServer
, systemFilepath, tagsoup, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time, fetchurl
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.3.3.0";
  sha256 = "11zfz55a7dr5l7xzknphqninyrb2pw2qmrs7v7ajq2gvbl0lf37n";
  isLibrary = true;
  isExecutable = true;
  patches = [ (fetchurl { url = "https://github.com/jaspervdj/hakyll/pull/183.patch";
                          sha256 = "0vjrxvgyc05nnshapjhk65pcamj9rigqff5q6wjbssx3ggqggrz9";
                          name = "hakyll-pandoc-fix.patch";
                        }) ];
  buildDepends = [
    binary blazeHtml blazeMarkup pandocCiteproc cmdargs cryptohash
    dataDefault deepseq filepath fsnotify httpConduit httpTypes
    lrucache mtl network pandoc parsec random regexBase regexTdfa
    snapCore snapServer systemFilepath tagsoup text time
  ];
  testDepends = [
    binary blazeHtml blazeMarkup pandocCiteproc cmdargs cryptohash
    dataDefault deepseq filepath fsnotify httpConduit httpTypes HUnit
    lrucache mtl network pandoc parsec QuickCheck random regexBase
    regexTdfa snapCore snapServer systemFilepath tagsoup testFramework
    testFrameworkHunit testFrameworkQuickcheck2 text time
  ];
  doCheck = false;
  postPatch = ''
    sed -i -e 's|cryptohash.*,|cryptohash,|' -e 's|tagsoup.*,|tagsoup,|' hakyll.cabal
  '';
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
