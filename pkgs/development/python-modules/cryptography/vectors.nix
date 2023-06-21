{ buildPythonPackage, fetchPypi, lib, cryptography, setuptools }:

buildPythonPackage rec {
  pname = "cryptography-vectors";
  # The test vectors must have the same version as the cryptography package
  inherit (cryptography) version;
  format = "pyproject";

  src = fetchPypi {
    pname = "cryptography_vectors";
    inherit version;
    hash = "sha256-I7CMOXd+x7J3ShH5RdF0YwGx6I7P8uUybX9Q6g9C1YA=";
  };

  nativeBuildInputs = [ setuptools ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [ "cryptography_vectors" ];

  meta = with lib; {
    description = "Test vectors for the cryptography package";
    homepage = "https://cryptography.io/en/latest/development/test-vectors/";
    downloadPage = "https://github.com/pyca/cryptography/tree/master/vectors";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
