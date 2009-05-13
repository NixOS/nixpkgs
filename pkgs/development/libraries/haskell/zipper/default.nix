{cabal, multirec}:

cabal.mkDerivation (self : {
  pname = "zipper";
  version = "0.2";
  sha256 = "174d2e19d2186511b190bd483f20492751262a6ea88f343fbacf7b40724fa222";
  propagatedBuildInputs = [multirec];
  meta = {
    description = "Generic zipper for systems of recursive datatypes";
  };
})  

