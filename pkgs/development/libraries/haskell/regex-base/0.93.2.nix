{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "regex-base";
  version = "0.93.2"; # Haskell Platform 2010.2.0.0, 2011.2.0.0
  sha256 = "0y1j4h2pg12c853nzmczs263di7xkkmlnsq5dlp5wgbgl49mgp10";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Replaces/Ehances Text.Regex";
  };
})  

