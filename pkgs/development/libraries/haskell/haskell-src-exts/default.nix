{cabal, cpphs, happy}:

cabal.mkDerivation (self : {
  pname = "haskell-src-exts";
  version = "0.4.8";
  sha256 = "f059f698681b262b2a4725735b99ecbafec721ccadab65fcf075c2fc5d346dec";
  extraBuildInputs = [happy];
  propagatedBuildInputs = [cpphs];
  meta = {
    description = "Manipulating Haskell source: abstract syntax, lexer, parser, and pretty-printer";
  };
})  

