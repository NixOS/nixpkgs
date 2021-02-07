{ buildPythonPackage, fetchPypi, lib, cryptography }:

buildPythonPackage rec {
  pname = "cryptography_vectors";
  # The test vectors must have the same version as the cryptography package:
  version = cryptography.version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yhaps0f3h2yjb6lmz953z1l1d84y9swk4k3gj9nqyk4vbx5m7cc";
  };

  # No tests included
  doCheck = false;

  meta = with lib; {
    description = "Test vectors for the cryptography package";
    homepage = "https://cryptography.io/en/latest/development/test-vectors/";
    # Source: https://github.com/pyca/cryptography/tree/master/vectors;
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ primeos ];
  };
}
