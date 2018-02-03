{ buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  # also bump cryptography
  pname = "cryptography_vectors";
  version = "2.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "78c4b4f3f84853ea5d038e2f53d355229dd8119fe9cf949c3e497c85c760a5ca";
  };

  # No tests included
  doCheck = false;
}