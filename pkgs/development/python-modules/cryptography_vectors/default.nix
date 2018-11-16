{ buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  # also bump cryptography
  pname = "cryptography_vectors";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf4d9b61dce69c49e830950aa36fad194706463b0b6dfe81425b9e0bc6644d46";
  };

  # No tests included
  doCheck = false;
}