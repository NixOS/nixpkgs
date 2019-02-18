{ buildPythonPackage, fetchPypi, lib }:

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

  meta = with lib; {
    description = "Test vectors for the cryptography package";
    homepage = https://cryptography.io/en/latest/development/test-vectors/;
    # Source: https://github.com/pyca/cryptography/tree/master/vectors;
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ primeos ];
  };
}
