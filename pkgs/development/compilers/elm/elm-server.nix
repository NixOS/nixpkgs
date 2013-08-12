{ cabal, blazeHtml, deepseq, Elm, filepath, happstackServer, HTTP
, mtl, parsec, transformers
}:

cabal.mkDerivation (self: {
  pname = "elm-server";
  version = "0.9";
  sha256 = "1mk2ligv8has1ssmpild2dq23ld84cdayr6bm3ycg11jab0hrbsx";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    blazeHtml deepseq Elm filepath happstackServer HTTP mtl parsec
    transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://elm-lang.org";
    description = "The Elm language server";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
