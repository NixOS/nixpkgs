{ buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  # also bump cryptography
  pname = "cryptography_vectors";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "356a2ded84ae379e556515eec9b68dd74957651a38465d10605bb9fbae280f15";
  };

  # No tests included
  doCheck = false;
}