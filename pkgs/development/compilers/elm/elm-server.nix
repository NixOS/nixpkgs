{ cabal, blazeHtml, deepseq, Elm, filepath, happstackServer, HTTP
, mtl, parsec, transformers
}:

cabal.mkDerivation (self: {
  pname = "elm-server";
  version = "0.10.1";
  sha256 = "0rh01jm9h9zbslnzy6xg7bin76gdmypannh3ly40azplw9xmf2dn";
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
