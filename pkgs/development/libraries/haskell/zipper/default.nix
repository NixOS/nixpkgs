{cabal, multirec}:

cabal.mkDerivation (self : {
  pname = "zipper";
  version = "0.3";
  sha256 = "3f6cc0ea69734d0523f1bf74d14953f88a196e728f89a7cc91f394d9e0c13c15";
  propagatedBuildInputs = [multirec];
  meta = {
    description = "Generic zipper for systems of recursive datatypes";
  };
})

