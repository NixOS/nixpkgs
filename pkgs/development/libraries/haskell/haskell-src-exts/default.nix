{cabal, cpphs, happy}:

cabal.mkDerivation (self : {
  pname = "haskell-src-exts";
  version = "1.9.6";
  sha256 = "1bdbjwhzms962ncwiszp82a8m6jkgz6d9cns5585kipy9n224d3h";
  extraBuildInputs = [happy];
  propagatedBuildInputs = [cpphs];
  meta = {
    description = "Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer";
  };
})  

