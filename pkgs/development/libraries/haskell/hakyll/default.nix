{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cmdargs
, cryptohash, dataDefault, deepseq, filepath, fsnotify, httpConduit
, httpTypes, HUnit, lrucache, mtl, network, pandoc, parsec
, QuickCheck, random, regexBase, regexTdfa, snapCore, snapServer
, systemFilepath, tagsoup, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.3.3.0";
  sha256 = "11zfz55a7dr5l7xzknphqninyrb2pw2qmrs7v7ajq2gvbl0lf37n";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary blazeHtml blazeMarkup citeprocHs cmdargs cryptohash
    dataDefault deepseq filepath fsnotify httpConduit httpTypes
    lrucache mtl network pandoc parsec random regexBase regexTdfa
    snapCore snapServer systemFilepath tagsoup text time
  ];
  testDepends = [
    binary blazeHtml blazeMarkup citeprocHs cmdargs cryptohash
    dataDefault deepseq filepath fsnotify httpConduit httpTypes HUnit
    lrucache mtl network pandoc parsec QuickCheck random regexBase
    regexTdfa snapCore snapServer systemFilepath tagsoup testFramework
    testFrameworkHunit testFrameworkQuickcheck2 text time
  ];
  doCheck = false;
  jailbreak = true;
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
