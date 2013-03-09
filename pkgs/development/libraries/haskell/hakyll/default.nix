{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cmdargs
, cryptohash, deepseq, filepath, httpConduit, httpTypes, HUnit
, lrucache, mtl, pandoc, parsec, QuickCheck, random, regexBase
, regexTdfa, snapCore, snapServer, tagsoup, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.2.1.1";
  sha256 = "072fl5k8fwmrx1rwb964cz0kn1hcyda13l597mqdmdi2ky5s5hf0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary blazeHtml blazeMarkup citeprocHs cmdargs cryptohash deepseq
    filepath httpConduit httpTypes lrucache mtl pandoc parsec random
    regexBase regexTdfa snapCore snapServer tagsoup text time
  ];
  testDepends = [
    binary blazeHtml blazeMarkup citeprocHs cmdargs cryptohash deepseq
    filepath httpConduit httpTypes HUnit lrucache mtl pandoc parsec
    QuickCheck random regexBase regexTdfa snapCore snapServer tagsoup
    testFramework testFrameworkHunit testFrameworkQuickcheck2 text time
  ];
  patchPhase = "sed -i -e 's|pandoc.*,|pandoc,|' hakyll.cabal";
  doCheck = false;
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
