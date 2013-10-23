{ cabal, aeson, aesonPretty, binary, blazeHtml, blazeMarkup
, cmdargs, filepath, HTF, indents, languageEcmascript, mtl, pandoc
, parsec, text, transformers, unionFind, uniplate
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.10";
  sha256 = "0wwda9w9r3qw7b23bj4qnfj4vgl7zwwnslxmgz3rv0cmxn9klqx2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson aesonPretty binary blazeHtml blazeMarkup cmdargs filepath
    indents languageEcmascript mtl pandoc parsec text transformers
    unionFind uniplate
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
