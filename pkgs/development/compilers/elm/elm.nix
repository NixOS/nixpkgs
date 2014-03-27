{ cabal, aeson, aesonPretty, binary, blazeHtml, blazeMarkup
, cmdargs, filemanip, filepath, HUnit, indents, languageEcmascript
, mtl, pandoc, parsec, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text, transformers
, unionFind, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.12";
  sha256 = "1gmhnpcfv49bdifvz70fif71947q482pd1dbs5c84m8sn7c5n3ss";
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
