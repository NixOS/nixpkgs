{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, setuptools
}:

buildPythonPackage rec {
  pname = "cryptography-vectors";
  # The test vectors must have the same version as the cryptography package
  inherit (cryptography) version;
  pyproject = true;

  src = fetchPypi {
    pname = "cryptography_vectors";
    inherit version;
    hash = "sha256-degq6imCcpMSr3Na2ymD80e7If/4itXdo2c+1w4dHK8=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # No tests included
  doCheck = false;

  pythonImportsCheck = [
    "cryptography_vectors"
  ];

  meta = with lib; {
    description = "Test vectors for the cryptography package";
    homepage = "https://cryptography.io/en/latest/development/test-vectors/";
    downloadPage = "https://github.com/pyca/cryptography/tree/master/vectors";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
