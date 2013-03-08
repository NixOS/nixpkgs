{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cmdargs
, cryptohash, deepseq, filepath, httpConduit, httpTypes, HUnit
, lrucache, mtl, pandoc, parsec, QuickCheck, random, regexBase
, regexTdfa, snapCore, snapServer, tagsoup, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.2.1.0";
  sha256 = "05w5j8wc47j8g4x2lsm0zs3aspb4rjvgnrxbjlxps0mfz3csqfhh";
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
    QuickCheck random regexBase regexTdfa tagsoup testFramework
    testFrameworkHunit testFrameworkQuickcheck2 text time
  ];
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
