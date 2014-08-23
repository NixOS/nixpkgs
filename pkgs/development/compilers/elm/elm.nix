{ cabal, aeson, aesonPretty, binary, blazeHtml, blazeMarkup
, cmdargs, filemanip, filepath, HUnit, indents, languageEcmascript
, languageGlsl, mtl, pandoc, parsec, QuickCheck, scientific
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, transformers, unionFind, unorderedContainers, yaml
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.12.3";
  sha256 = "1v6h9qbbz27ikh19xwjbyfw0zi5ag9x1gp0khh9v4af1g0j86320";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson aesonPretty binary blazeHtml blazeMarkup cmdargs filepath
    indents languageEcmascript languageGlsl mtl pandoc parsec
    scientific text transformers unionFind unorderedContainers yaml
  ];
  testDepends = [
    aeson aesonPretty binary blazeHtml blazeMarkup cmdargs filemanip
    filepath HUnit indents languageEcmascript languageGlsl mtl pandoc
    parsec QuickCheck scientific testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text transformers unionFind
    unorderedContainers yaml
  ];
  doCheck = false;
  preConfigure = ''
    rm -f Setup.hs
    echo -e "import Distribution.Simple\nmain=defaultMain\n" > Setup.hs
  '';
  meta = {
    homepage = "http://elm-lang.org";
    description = "The Elm language module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
