{cabal, parsec, pcreLight, xhtml}:

cabal.mkDerivation (self : {
  pname = "highlighting-kate";
  version = "0.2.5";
  sha256 = "0a11f29a61b9c907d3b79540e0b2ac3b6194bd4bc37b6405973cd9eeb7a9a868";
  propagatedBuildInputs = [parsec pcreLight xhtml];
  meta = {
    description = "Syntax highlighting";
  };
})  
