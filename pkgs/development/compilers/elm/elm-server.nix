{ cabal, blazeHtml, deepseq, Elm, filepath, happstackServer, HTTP
, mtl, parsec, transformers
}:

cabal.mkDerivation (self: {
  pname = "elm-server";
  version = "0.8";
  sha256 = "0mnxayfg54f5mr27sd1zw3xrdijppgvrz2yzzmhp07qc1jiyfald";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    blazeHtml deepseq Elm filepath happstackServer HTTP mtl parsec
    transformers
  ];
  meta = {
    homepage = "http://elm-lang.org";
    description = "The Elm language server";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
