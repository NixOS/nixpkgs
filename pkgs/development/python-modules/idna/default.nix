{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "idna";
  version = "2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb";
  };

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}