{ cabal, aeson, aesonPretty, binary, blazeHtml, blazeMarkup
, cmdargs, filemanip, filepath, HUnit, indents, languageEcmascript
, mtl, pandoc, parsec, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text, transformers
, unionFind, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.12.1.3";
  sha256 = "1p4py4qyxsp25qa8141ywfh0qnvdid4v7xlbqkk8aafxccb7lsm9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson aesonPretty binary blazeHtml blazeMarkup cmdargs filepath
    indents languageEcmascript mtl pandoc parsec text transformers
    unionFind unorderedContainers
  ];
  testDepends = [
    aeson aesonPretty binary blazeHtml blazeMarkup cmdargs filemanip
    filepath HUnit indents languageEcmascript mtl pandoc parsec
    QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text transformers unionFind
    unorderedContainers
  ];
  doCheck = false;
  meta = {
    homepage = "http://elm-lang.org";
    description = "The Elm language module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
