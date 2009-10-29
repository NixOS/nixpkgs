{cabal, haskeline, mtl}:

cabal.mkDerivation (self : {
  pname = "haskeline-class";
  version = "0.6.1";
  sha256 = "da954acea7ae215865a647fff776df9621ee5c5133a5f95c16b1ac5646ef0b31";
  propagatedBuildInputs = [haskeline mtl];
  meta = {
    description = "Class interface for working with Haskeline";
  };
})  

