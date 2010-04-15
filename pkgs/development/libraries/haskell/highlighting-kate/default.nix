{cabal, parsec, pcreLight, xhtml}:

cabal.mkDerivation (self : {
  pname = "highlighting-kate";
  version = "0.2.6.2";
  sha256 = "3ed163888d45d5bf5ee5c2931e894f6ca2eb167a79ac8274d7f57341c4c5dca7";
  propagatedBuildInputs = [parsec pcreLight xhtml];
  meta = {
    description = "Syntax highlighting";
  };
})  
