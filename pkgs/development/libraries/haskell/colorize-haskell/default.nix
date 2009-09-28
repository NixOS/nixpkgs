{cabal, ansiTerminal, haskellLexer}:

cabal.mkDerivation (self : {
  pname = "colorize-haskell";
  version = "1.0.0";
  sha256 = "14c180ea3e8beb12dd289c51453bd2e3583f306799db4630c8f86cf09bbb3763";
  propagatedBuildInputs = [ansiTerminal haskellLexer];
  meta = {
    description = "Highlight Haskell source";
  };
})  

