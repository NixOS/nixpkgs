{ cabal, binary, blazeHtml, blazeMarkup, citeprocHs, cmdargs
, cryptohash, deepseq, filepath, httpConduit, httpTypes, HUnit
, lrucache, mtl, pandoc, parsec, QuickCheck, random, regexBase
, regexTdfa, snapCore, snapServer, tagsoup, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text, time
}:

cabal.mkDerivation (self: {
  pname = "hakyll";
  version = "4.1.4.0";
  sha256 = "0nhr7ai03hx2qjxlqml0js43iwxhcbpdqkwdvw8pqs396yrjwxdj";
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
  jailbreak = true;
  meta = {
    homepage = "http://jaspervdj.be/hakyll";
    description = "A static website compiler library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
