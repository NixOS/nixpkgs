{cabal, cpphs, happy}:

cabal.mkDerivation (self : {
  pname = "haskell-src-exts";
  version = "1.1.4";
  sha256 = "83c98d8bc16622039b14220190c571ed7f8459f129803b593373df5c15e3f2f1";
  extraBuildInputs = [happy];
  propagatedBuildInputs = [cpphs];
  meta = {
    description = "Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer";
  };
})  

