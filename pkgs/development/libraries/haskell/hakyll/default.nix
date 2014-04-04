{ cabal, binary, blazeHtml, blazeMarkup, cmdargs, cryptohash
, dataDefault, deepseq, filepath, fsnotify, httpConduit, httpTypes
, HUnit, lrucache, mtl, network, pandoc, pandocCiteproc, parsec
, QuickCheck, random, regexBase, regexTdfa, snapCore, snapServer
, systemFilepath, tagsoup, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.5.0.1";
  sha256 = "0zl8zjwkyrh5c0l190q6qw1w6mwhw7jsjk3l7qjpgxbmv730q7nz";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary blazeHtml blazeMarkup cmdargs cryptohash dataDefault deepseq
    filepath fsnotify httpConduit httpTypes lrucache mtl network pandoc
    pandocCiteproc parsec random regexBase regexTdfa snapCore
    snapServer systemFilepath tagsoup text time
  ];
  testDepends = [
    binary blazeHtml blazeMarkup cmdargs cryptohash dataDefault deepseq
    filepath fsnotify httpConduit httpTypes HUnit lrucache mtl network
    pandoc pandocCiteproc parsec QuickCheck random regexBase regexTdfa
    snapCore snapServer systemFilepath tagsoup testFramework
    testFrameworkHunit testFrameworkQuickcheck2 text time
  ];
  doCheck = false;
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
