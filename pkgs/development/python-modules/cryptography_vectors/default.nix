{ buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  # also bump cryptography
  pname = "cryptography_vectors";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28b52c84bae3a564ce51bfb0753cbe360218bd648c64efa2808c886c18505688";
  };

  # No tests included
  doCheck = false;
}