{ cabal, aeson, aesonPretty, binary, blazeHtml, blazeMarkup
, cmdargs, filemanip, filepath, HUnit, indents, languageEcmascript
, mtl, pandoc, parsec, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text, transformers
, unionFind, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.11";
  sha256 = "1rg1dbd2ag63in6069p6v88h1yx0snap2gdhz81lk9l66qns3f4s";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson aesonPretty binary blazeHtml blazeMarkup cmdargs filepath
    indents languageEcmascript mtl pandoc parsec text transformers
    unionFind unorderedContainers
  ];
  testDepends = [
    aeson binary blazeHtml blazeMarkup cmdargs filemanip filepath HUnit
    indents languageEcmascript mtl pandoc parsec QuickCheck
    testFramework testFrameworkHunit testFrameworkQuickcheck2 text
    transformers unionFind unorderedContainers
  ];
  doCheck = false;
  meta = {
    homepage = "http://elm-lang.org";
    description = "The Elm language module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
