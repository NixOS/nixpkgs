{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cmdargs
, cryptohash, dataDefault, deepseq, filepath, fsnotify, httpConduit
, httpTypes, HUnit, lrucache, mtl, network, pandoc, parsec
, QuickCheck, random, regexBase, regexTdfa, snapCore, snapServer
, systemFilepath, tagsoup, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.3.1.0";
  sha256 = "1cx5pf0wf49cylbcgy1di218qk0fw8rgzqri9lx1v8jfl31zvsg5";
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
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
