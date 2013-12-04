{ cabal, aeson, aesonPretty, binary, blazeHtml, blazeMarkup
, cmdargs, filepath, HTF, indents, languageEcmascript, mtl, pandoc
, parsec, text, transformers, unionFind, uniplate
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.10.0.2";
  sha256 = "08aqz9lf754ygdwvjf4bs5ivnjyjx9rd43vrbzp0p4d3if6w6avz";
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
