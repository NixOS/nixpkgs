{cabal, cpphs, happy}:

cabal.mkDerivation (self : {
  pname = "haskell-src-exts";
  version = "1.0.1";
  sha256 = "ccf6d43d25419ed3fbd1c26f2f3ac4af934884239f0ffcc80836aec8d3cbcf24";
  extraBuildInputs = [happy];
  propagatedBuildInputs = [cpphs];
  meta = {
    description = "Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer";
  };
})  

