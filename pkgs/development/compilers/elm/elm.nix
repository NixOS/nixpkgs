{ cabal, binary, blazeHtml, blazeMarkup, cmdargs, filepath, hjsmin
, indents, mtl, pandoc, parsec, transformers, unionFind, uniplate
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.9.0.1";
  sha256 = "0p6sqfrf11xpgj7y81hsjbvsyyyfvc4nzcg6gmfwyqkg3qc3yg6v";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary blazeHtml blazeMarkup cmdargs filepath hjsmin indents mtl
    pandoc parsec transformers unionFind uniplate
  ];
  doCheck = false;
  meta = {
    homepage = "http://elm-lang.org";
    description = "The Elm language module";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
