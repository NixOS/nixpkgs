{ cabal, blazeHtml, blazeMarkup, cmdargs, deepseq, filepath, hjsmin
, indents, json, mtl, pandoc, parsec, shakespeare, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.8.0.3";
  sha256 = "0zai8glmkiqramivgz405zh385cz166gpry2yl29g37dxpwxffzb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeHtml blazeMarkup cmdargs deepseq filepath hjsmin indents json
    mtl pandoc parsec shakespeare text transformers
  ];
  meta = {
    homepage = "http://elm-lang.org";
    description = "The Elm language module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
