{cabal,mtl}:

cabal.mkDerivation (self : {
  pname = "parsec";
  version = "3.0.1";
  sha256 = "619d0c2eb093cfe6d6caab2ff94f31a6208720b4bcc85b9f98600253bb505542";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Monadic parser combinators";
  };
})  

