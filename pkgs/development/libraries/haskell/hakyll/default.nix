{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cmdargs
, cryptohash, dataDefault, deepseq, filepath, fsnotify, httpConduit
, httpTypes, HUnit, lrucache, mtl, pandoc, parsec, QuickCheck
, random, regexBase, regexTdfa, snapCore, snapServer
, systemFilepath, tagsoup, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.3.0.0";
  sha256 = "188j3spdi2mivx5a10whpb09fm8yhg54ddfwc6x0k040c7q3aq0q";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary blazeHtml blazeMarkup citeprocHs cmdargs cryptohash
    dataDefault deepseq filepath fsnotify httpConduit httpTypes
    lrucache mtl pandoc parsec random regexBase regexTdfa snapCore
    snapServer systemFilepath tagsoup text time
  ];
  testDepends = [
    binary blazeHtml blazeMarkup citeprocHs cmdargs cryptohash
    dataDefault deepseq filepath fsnotify httpConduit httpTypes HUnit
    lrucache mtl pandoc parsec QuickCheck random regexBase regexTdfa
    snapCore snapServer systemFilepath tagsoup testFramework
    testFrameworkHunit testFrameworkQuickcheck2 text time
  ];
  doCheck = false;
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
