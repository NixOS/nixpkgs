{ cabal, binary, blazeHtml, blazeMarkup, cmdargs, filepath, hjsmin
, indents, mtl, pandoc, parsec, transformers, unionFind, uniplate
}:

cabal.mkDerivation (self: {
  pname = "Elm";
  version = "0.9.0.2";
  sha256 = "0yr395wsj0spi6h9d6lm5hvdryybpf8i1qpv4gz9dk0bwlyc8iwh";
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
