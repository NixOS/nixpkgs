{cabal, cpphs, happy}:

cabal.mkDerivation (self : {
  pname = "haskell-src-exts";
  version = "1.9.0";
  sha256 = "dedb529217dfe393f75f26b735f7dd09eea50006481f60d06e169de6f328d1da";
  extraBuildInputs = [happy];
  propagatedBuildInputs = [cpphs];
  meta = {
    description = "Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer";
  };
})  

