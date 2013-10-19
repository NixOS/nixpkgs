{ cabal, binary, blazeHtml, blazeMarkup, cmdargs, cryptohash
, dataDefault, deepseq, filepath, fsnotify, httpConduit, httpTypes
, HUnit, lrucache, mtl, network, pandoc, pandocCiteproc, parsec
, QuickCheck, random, regexBase, regexTdfa, snapCore, snapServer
, systemFilepath, tagsoup, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.4.1.1";
  sha256 = "1jrswf9nk72n0a32mzarkv8x728dnjs68kijpgh35m6y10fsn4d8";
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
  patchPhase = ''
    sed -i -e 's|cryptohash.*,|cryptohash,|' -e 's|tagsoup.*,|tagsoup,|' hakyll.cabal
  '';
  doCheck = false;
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
