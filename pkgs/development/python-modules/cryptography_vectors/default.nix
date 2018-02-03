{ buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  # also bump cryptography
  pname = "cryptography_vectors";
  version = cryptography.version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "beb831aa73663a224f4d7520483ed02da544533bb03b26ec07a5f9a0dd0941e1";
  };

  # No tests included
  doCheck = false;
}