{ cabal, blazeHtml, deepseq, Elm, filepath, happstackServer, HTTP
, mtl, parsec, transformers
}:

cabal.mkDerivation (self: {
  pname = "elm-server";
  version = "0.9.0.2";
  sha256 = "0g362llb7jkwz8xhyhhsc8hz0vj7s7bgfz1az5qfh1cm4h8nynwr";
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
