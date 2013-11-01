{ cabal, aeson, aesonPretty, binary, blazeHtml, blazeMarkup
, cmdargs, filepath, HTF, indents, languageEcmascript, mtl, pandoc
, parsec, text, transformers, unionFind, uniplate
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.10.0.1";
  sha256 = "1r7z2fw9v6ngr9w4lmj1l6sc78rmxvqkqlxv4a9yc5jm80k3ar0i";
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
