{cabal, parsec, pcreLight, xhtml}:

cabal.mkDerivation (self : {
  pname = "highlighting-kate";
  version = "0.2.9";
  sha256 = "0mk8m01mqw6vnjldr5idc6611475j4m292cm18kn3wa83000mbgk";
  propagatedBuildInputs = [parsec pcreLight xhtml];
  meta = {
    description = "Syntax highlighting";
  };
})  
