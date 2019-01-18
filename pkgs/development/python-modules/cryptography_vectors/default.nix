{ buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  # also bump cryptography
  pname = "cryptography_vectors";
  version = "2.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "013qx2hz0jv79yzfzpn0r2kk33i5qy3sdnzgwiv5779d18snblwi";
  };

  # No tests included
  doCheck = false;
}
