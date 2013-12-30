{ cabal, aeson, aesonPretty, binary, blazeHtml, blazeMarkup
, cmdargs, filepath, HTF, indents, languageEcmascript, mtl, pandoc
, parsec, text, transformers, unionFind, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.10.1";
  sha256 = "1y533vanhrxc14x304ig6q8ch6zih8yqgpfgw4h5vk5fpdmn09a2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson aesonPretty binary blazeHtml blazeMarkup cmdargs filepath
    indents languageEcmascript mtl pandoc parsec text transformers
    unionFind unorderedContainers
  ];
  testDepends = [ HTF ];
  doCheck = false;
  meta = {
    homepage = "http://elm-lang.org";
    description = "The Elm language module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
