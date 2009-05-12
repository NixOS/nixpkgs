{cabal, multirec}:

cabal.mkDerivation (self : {
  pname = "zipper";
  version = "0.1";
  sha256 = "aa4d45692be1a54ebe4bd0df9577a09d95692930494103c2ee89dfce7af818eb";
  propagatedBuildInputs = [multirec];
  meta = {
    description = "Generic zipper for systems of recursive datatypes";
  };
})  

