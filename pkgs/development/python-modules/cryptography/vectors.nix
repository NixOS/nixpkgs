{ buildPythonPackage, fetchPypi, lib, cryptography }:

buildPythonPackage rec {
  pname = "cryptography-vectors";
  # The test vectors must have the same version as the cryptography package
  inherit (cryptography) version;

  src = fetchPypi {
    pname = "cryptography_vectors";
    inherit version;
    hash = "sha256-HNr9QvU0jXfk5+R5Gu/R9isWvVUqAnSvyTRlM/4y6SU=";
  };

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "cryptography_vectors" ];

  meta = with lib; {
    description = "Test vectors for the cryptography package";
    homepage = "https://cryptography.io/en/latest/development/test-vectors/";
    # Source: https://github.com/pyca/cryptography/tree/master/vectors;
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
