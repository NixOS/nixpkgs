{cabal, parsec, pcreLight, xhtml}:

cabal.mkDerivation (self : {
  pname = "highlighting-kate";
  version = "0.2.7.1";
  sha256 = "330c5fdc6b5dae62c12ee2455892319df12723346aa75401aea05ea0b24cf5ed";
  propagatedBuildInputs = [parsec pcreLight xhtml];
  meta = {
    description = "Syntax highlighting";
  };
})  
